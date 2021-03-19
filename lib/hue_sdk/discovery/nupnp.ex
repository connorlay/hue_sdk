defmodule HueSDK.Discovery.NUPNP do
  @moduledoc """
  N-UPnP discovery of the Hue Bridge.
  """

  require Logger

  @behaviour HueSDK.Discovery

  @impl true
  def do_discovery(opts) do
    devices =
      poll_for_discovery(
        HueSDK.Config.portal_url(),
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

    case HueSDK.HTTP.request(:get, nupnp_url, [], nil, &Jason.decode!/1) do
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
    %HueSDK.Bridge{host: device["internalipaddress"]}
  end
end
