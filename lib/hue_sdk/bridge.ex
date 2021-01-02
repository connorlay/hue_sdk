defmodule HueSDK.Bridge do
  @moduledoc """
  Interface to the Hue Bridge, required for all calls to the Hue SDK Rest API
  """

  alias HueSDK.API.Configuration
  alias HueSDK.Discovery.{MDNS, NUPNP}

  require Logger

  defstruct [
    :api_version,
    :bridge_id,
    :datastore_version,
    :host,
    :mac,
    :model_id,
    :name,
    :sw_version,
    :username
  ]

  @doc """
  Automatic discovery of the Hue Bridge
  """
  def discover() do
    bridge = do_discovery_flow()
    {:ok, config} = Configuration.get_bridge_config(bridge)

    Map.merge(bridge, %{
      api_version: config["apiversion"],
      datastore_version: config["datastoreversion"],
      model_id: config["modelid"],
      mac: config["mac"],
      name: config["name"],
      sw_version: config["swversion"]
    })
  end

  defp do_discovery_flow() do
    with {:nupnp, nil} <- NUPNP.discover(),
         {:mdns, nil} <- MDNS.discover() do
      nil
    else
      {:nupnp, device} ->
        %__MODULE__{
          host: device["internalipaddress"],
          bridge_id: device["id"]
        }

      {:mdns, device} ->
        %__MODULE__{
          host: ip_tuple_to_host(device.ip),
          bridge_id: device.payload["bridgeid"]
        }
    end
  end

  @doc """
  """
  def authenticate(bridge, devicetype) do
    username =
      case Configuration.create_user(bridge, devicetype) do
        {:ok, [%{"success" => %{"username" => username}}]} ->
          Logger.debug("Bridge created username '#{username}' for devicetype '#{devicetype}'")
          username

        {:ok, [%{"error" => error}]} ->
          Logger.warn(
            "Bridge failed to create username for devicetype '#{devicetype}' with error '#{
              inspect(error)
            }'"
          )
      end

    %{bridge | username: username}
  end

  def write_to_disk(bridge) do
    ensure_bridge_directory()
    bridge_file = Path.join([bridge_directory(), bridge.bridge_id])
    File.write!(bridge_file, :erlang.term_to_binary(bridge))
    Logger.debug("Bridge write to '#{bridge_file}'")
    :ok
  end

  def read_from_disk() do
    ensure_bridge_directory()

    for bridge_id <- File.ls!(bridge_directory()) do
      bridge_file = Path.join([bridge_directory(), bridge_id])

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

    for bridge_id <- File.ls!(bridge_directory()) do
      bridge_file = Path.join([bridge_directory(), bridge_id])
      File.rm!(bridge_file)
      Logger.debug("Bridge deleted from '#{bridge_file}'")
    end

    :ok
  end

  defp ensure_bridge_directory() do
    if File.exists?(bridge_directory()) do
      :ok
    else
      Logger.debug("Bridge directory created at '#{bridge_directory()}'")
      File.mkdir_p!(bridge_directory())
    end
  end

  defp ip_tuple_to_host({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"

  defp bridge_directory(), do: Path.expand("~/.hue_sdk/bridge/")
end
