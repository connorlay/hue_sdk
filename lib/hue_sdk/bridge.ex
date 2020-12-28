defmodule HueSDK.Bridge do
  @moduledoc """
  Interface to the Hue Bridge, required for all calls to the Hue SDK Rest API
  """

  @bridge_directory Path.expand("~/.hue_sdk/bridge/")

  require Logger

  defstruct [
    :api_version,
    :bridge_id,
    :datastore_version,
    :domain,
    :host,
    :mac,
    :model_id,
    :name,
    :sw_version,
    :username
  ]

  @doc """
  Automatic discovery of the Hue Bridge

  Currently only supports mDNS via `HueSDK.Discovery.MDNS`
  """
  def discover() do
    case HueSDK.Discovery.MDNS.discover() do
      nil ->
        nil

      device ->
        bridge = %__MODULE__{
          host: ip_tuple_to_host(device.ip),
          domain: device.domain,
          bridge_id: device.payload["bridgeid"],
          model_id: device.payload["modelid"]
        }

        config = HueSDK.API.Configuration.get_bridge_config(bridge)

        Map.merge(bridge, %{
          api_version: config["apiversion"],
          datastore_version: config["datastoreversion"],
          mac: config["mac"],
          name: config["name"],
          sw_version: config["swversion"]
        })
    end
  end

  @doc """
  """
  def authenticate(bridge, devicetype) do
    username =
      case HueSDK.API.Configuration.create_user(bridge, devicetype) do
        [%{"success" => %{"username" => username}}] ->
          Logger.debug("Bridge created username '#{username}' for devicetype '#{devicetype}'")
          username

        error ->
          Logger.warn(
            "Bridge failed to create username for devicetype '#{devicetype}' with error '#{
              inspect(error)
            }'"
          )

          nil
      end

    %{bridge | username: username}
  end

  def write_to_disk(bridge) do
    ensure_bridge_directory()
    bridge_file = Path.join([@bridge_directory, bridge.bridge_id])
    File.write!(bridge_file, :erlang.term_to_binary(bridge))
    Logger.debug("Bridge write to '#{bridge_file}'")
    :ok
  end

  def read_from_disk() do
    ensure_bridge_directory()

    for bridge_id <- File.ls!(@bridge_directory) do
      bridge_file = Path.join([@bridge_directory, bridge_id])

      bridge =
        bridge_file
        |> File.read!()
        |> :erlang.binary_to_term()

      Logger.debug("Bridge read from '#{bridge_file}'")

      bridge
    end
  end

  def cleanup() do
    ensure_bridge_directory()

    for bridge_id <- File.ls!(@bridge_directory) do
      bridge_file = Path.join([@bridge_directory, bridge_id])
      File.rm!(bridge_file)
      Logger.debug("Bridge deleted from '#{bridge_file}'")
    end

    :ok
  end

  defp ensure_bridge_directory() do
    if File.exists?(@bridge_directory) do
      :ok
    else
      Logger.debug("Bridge directory created at '#{@bridge_directory}'")
      File.mkdir_p!(@bridge_directory)
    end
  end

  defp ip_tuple_to_host({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
end
