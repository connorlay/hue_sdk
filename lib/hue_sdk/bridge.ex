defmodule HueSDK.Bridge do
  @moduledoc """
  Interface to the Philips Hue Bridge, required for all calls to `HueSDK.API`.
  """

  alias HueSDK.API.Configuration

  require Logger

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

  @typedoc """
  A unique identifier to register with the Hue Bridge API.
  """
  @type devicetype :: String.t()

  @doc """
  Authenticates a new devicetype with the Hue Bridge API.

  ## Examples

    HueSDK.Bridge.authenticate(bridge, "user#huesdk")
    %HueSDK.Bridge{username: ""}
  """
  @spec authenticate(t(), devicetype()) :: t()
  def authenticate(%__MODULE__{} = bridge, devicetype) when is_binary(devicetype) do
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

  # Private helper functions for local development. Do not use me!

  @bridge_directory "~/.config/hue_sdk"

  @doc false
  def write_to_disk(%__MODULE__{} = bridge) do
    bridge_directory = ensure_bridge_directory()
    bridge_file = Path.join([bridge_directory, bridge.bridge_id])
    File.write!(bridge_file, :erlang.term_to_binary(bridge))
    Logger.debug("Bridge write to '#{bridge_file}'")
    :ok
  end

  @doc false
  def read_from_disk() do
    bridge_directory = ensure_bridge_directory()

    for bridge_id <- File.ls!(bridge_directory) do
      bridge_file = Path.join([bridge_directory, bridge_id])

      bridge =
        bridge_file
        |> File.read!()
        |> :erlang.binary_to_term()

      Logger.debug("Bridge read from '#{bridge_file}'")

      bridge
    end
  end

  @doc false
  def cleanup() do
    bridge_directory = ensure_bridge_directory()

    for bridge_id <- File.ls!(bridge_directory) do
      bridge_file = Path.join([bridge_directory, bridge_id])
      File.rm!(bridge_file)
      Logger.debug("Bridge deleted from '#{bridge_file}'")
    end

    :ok
  end

  defp ensure_bridge_directory() do
    bridge_directory = Path.expand(@bridge_directory)

    unless File.exists?(bridge_directory) do
      Logger.debug("Bridge directory created at '#{bridge_directory}'")
      File.mkdir_p!(bridge_directory)
    end

    bridge_directory
  end
end
