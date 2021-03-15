defmodule HueSDK.Discovery.NUPNP do
  @moduledoc """
  N-UPnP discovery of the Hue Bridge.
  """

  alias HueSDK.{Discovery, HTTP, JSON, Config}

  require Logger

  @behaviour Discovery

  @impl true
  def do_discovery(opts) do
    devices =
      poll_for_discovery(
        Config.hue_portal_url(),
        opts[:max_attempts],
        opts[:sleep]
      )

    {:nupnp, Enum.map(devices, &to_bridge/1)}
  end

  defp poll_for_discovery(nupnp_url, max_attempts, sleep) do
    poll_for_discovery(nupnp_url, max_attempts, sleep, 1)
  end

  defp poll_for_discovery(nupnp_url, max_attempts, sleep, attempt_no)
       when attempt_no <= max_attempts do
    Logger.debug("N-UPnP discovery attempt #{attempt_no}/#{max_attempts}..")
    [scheme, host] = String.split(nupnp_url, "://")

    case HTTP.request(:get, String.to_existing_atom(scheme), host, [], nil, &JSON.decode!/1) do
      {:ok, devices} when is_list(devices) ->
        Logger.debug("N-UPnP discovered devices #{inspect(devices)}")
        devices

      _ ->
        :timer.sleep(sleep)
        poll_for_discovery(nupnp_url, max_attempts, sleep, attempt_no + 1)
    end
  end

  defp poll_for_discovery(_namespace, max_attempts, _sleep, _attempt_no) do
    Logger.warn("N-UPnP exhausted #{max_attempts} discovery attempts!")
    []
  end

  defp to_bridge(device) do
    %HueSDK.Bridge{
      host: device["internalipaddress"],
      bridge_id: device["id"],
      scheme: Config.bridge_scheme()
    }
  end
end
