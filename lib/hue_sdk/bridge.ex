defmodule HueSDK.Bridge do
  @moduledoc """
  Interface to the Philips Hue Bridge, required for all calls to `HueSDK.API`.
  """

  alias HueSDK.API.Configuration
  alias HueSDK.Discovery.{MDNS, NUPNP}

  require Logger

  @bridge_directory "~/.hue_sdk/bridge/"

  @typedoc """
  Stateless struct containing Hue Bridge connection information.
  """
  @type t :: %__MODULE__{}
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
  Automatic discovery of the Hue Bridge.

  Attempts N-UPnP discovery, followed by mDNS. If both fail,
  the bridge can be manually created by creating a new 
  instance of the `HueSDK.Bridge` struct.
  """
  @spec discover() :: t() | nil
  def discover() do
    case do_discovery_flow() do
      nil ->
        Logger.error("Bridge discovery failed.")
        nil

      bridge ->
        Logger.debug("Bridge discovered.")
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
  end

  @doc """
  Authenticates with the Hue Bridge.
  """
  @spec authenticate(t(), String.t()) :: t()
  def authenticate(bridge, devicetype) do
    case Configuration.create_user(bridge, devicetype) do
      {:ok, [%{"success" => %{"username" => username}}]} ->
        Logger.info("Bridge created username '#{username}' for devicetype '#{devicetype}'")
        %{bridge | username: username}

      {:ok, [%{"error" => %{"description" => description}}]} ->
        Logger.warn(
          "Bridge failed to create user for devicetype '#{devicetype}': '#{description}'"
        )

        bridge

      {_status, error} ->
        Logger.error("Bridge connection failed with error '#{inspect(error)}'")
        bridge
    end
  end

  @doc """
  Serializes and writes the Hue Bridge on disk.

  Files are written to #{@bridge_directory}
  """
  @spec write_to_disk(t()) :: :ok
  def write_to_disk(bridge) do
    ensure_bridge_directory()
    bridge_file = Path.join([bridge_directory(), bridge.bridge_id])
    File.write!(bridge_file, :erlang.term_to_binary(bridge))
    Logger.debug("Bridge write to '#{bridge_file}'")
    :ok
  end

  @doc """
  Deserializes all Hue Bridges filess tored on disk.

  Files are read from #{@bridge_directory}
  """
  @spec read_from_disk() :: [t()]
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

  @doc """
  Deletes all Hue Bridge files stored on disk.

  Files are removed from #{@bridge_directory}
  """
  @spec cleanup() :: :ok
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

  defp ip_tuple_to_host({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"

  defp bridge_directory(), do: Path.expand(@bridge_directory)
end
