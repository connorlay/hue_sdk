defmodule HueSDK.Bridge do
  @moduledoc """
  Interface to the Hue Bridge device, required to call functions in the `HueSDK.API` namespace.
  """

  alias HueSDK.API.Configuration

  require Logger

  @typedoc """
  A unique identifier to register with the Hue Bridge API.

  ## Examples

      "connorlay#huesdk"
  """
  @type devicetype :: String.t()

  @typedoc """
  Stateless struct containing Hue Bridge device information.

  ## Examples

      %HueSDK.Bridge{
        api_version: "1.42.0",
        bridge_id: "EGB5FAFAFE196528",
        datastore_version: "99",
        host: "192.168.1.2",
        mac: "f0:dd:e5:1f:38:cd",
        model_id: "BSB002",
        name: "My Hue Bridge",
        sw_version: "1943082030",
        username: "Ht-Flaev-p7Vk5ryJinxKwlYdQupdEXL4c5lKLXL"
      }
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
  Authenticates a new `t:devicetype/0` with the Hue Bridge REST API.
  For authentication to succeed, the link button on the Hue Bridge
  device must be pressed within 30 seconds of invoking this function.

  ## Examples

      HueSDK.Bridge.authenticate(bridge, "connorlay#huesdk")

      %HueSDK.Bridge{
       username: "Ht-Flaev-p7Vk5ryJinxKwlYdQupdEXL4c5lKLXL",
       # ...
      }
  """
  @spec authenticate(t(), devicetype()) :: t()
  def authenticate(%__MODULE__{} = bridge, devicetype) when is_binary(devicetype) do
    case Configuration.create_user(bridge, devicetype) do
      {:ok, [%{"success" => %{"username" => username}}]} ->
        Logger.info(
          "[#{__MODULE__}] Bridge created username '#{username}' for devicetype '#{devicetype}'"
        )

        %{bridge | username: username}

      {:ok, [%{"error" => %{"description" => description}}]} ->
        Logger.warn(
          "[#{__MODULE__}] Bridge failed to create user for devicetype '#{devicetype}': '#{
            description
          }'"
        )

        bridge

      {_status, error} ->
        Logger.error("[#{__MODULE__}] Bridge connection failed with error '#{inspect(error)}'")
        bridge
    end
  end

  @bridge_directory "~/.config/hue_sdk"

  @doc false
  def __write_to_disk__(%__MODULE__{} = bridge) do
    bridge_directory = __ensure_bridge_directory__()
    bridge_file = Path.join([bridge_directory, bridge.bridge_id])
    File.write!(bridge_file, :erlang.term_to_binary(bridge))
    Logger.debug("[#{__MODULE__}] Bridge write to '#{bridge_file}'")
    :ok
  end

  @doc false
  def __read_from_disk__ do
    bridge_directory = __ensure_bridge_directory__()

    for bridge_id <- File.ls!(bridge_directory) do
      bridge_file = Path.join([bridge_directory, bridge_id])

      bridge =
        bridge_file
        |> File.read!()
        |> :erlang.binary_to_term()

      Logger.debug("[#{__MODULE__}] Bridge read from '#{bridge_file}'")

      bridge
    end
  end

  @doc false
  def __cleanup__ do
    bridge_directory = __ensure_bridge_directory__()

    for bridge_id <- File.ls!(bridge_directory) do
      bridge_file = Path.join([bridge_directory, bridge_id])
      File.rm!(bridge_file)
      Logger.debug("[#{__MODULE__}] Bridge deleted from '#{bridge_file}'")
    end

    :ok
  end

  defp __ensure_bridge_directory__ do
    bridge_directory = Path.expand(@bridge_directory)

    unless File.exists?(bridge_directory) do
      Logger.debug("[#{__MODULE__}] Bridge directory created at '#{bridge_directory}'")
      File.mkdir_p!(bridge_directory)
    end

    bridge_directory
  end
end
