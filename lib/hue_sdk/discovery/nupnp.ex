defmodule HueSDK.Discovery.NUPNP do
  @moduledoc """
  N-UPnP discovery of the Hue Bridge.

  Requires a Hue Bridge registered with the official Philips Hue Discovery Portal.

  See `HueSDK.Discovery` for available options.
  """

  alias HueSDK.{Bridge, Config, Discovery, HTTP}

  require Logger

  @behaviour Discovery

  @impl true
  def do_discovery(opts) do
    devices =
      poll_for_discovery(
        Config.portal_host(),
        opts[:max_attempts],
        opts[:sleep]
      )

    {:nupnp, Enum.map(devices, &to_bridge/1)}
  end

  defp poll_for_discovery(portal_host, max_attempts, sleep) do
    poll_for_discovery(portal_host, max_attempts, sleep, 1)
  end

  defp poll_for_discovery(portal_host, max_attempts, sleep, attempt_no)
       when attempt_no <= max_attempts do
    Logger.debug("[#{__MODULE__}] discovery attempt #{attempt_no}/#{max_attempts}..")

    case HTTP.request(:get, portal_host, [], nil, &Jason.decode!/1) do
      {:ok, devices} when is_list(devices) ->
        Logger.debug("[#{__MODULE__}] discovered devices #{inspect(devices)}")
        devices

      _ ->
        :timer.sleep(sleep)
        poll_for_discovery(portal_host, max_attempts, sleep, attempt_no + 1)
    end
  end

  defp poll_for_discovery(_portal_host, max_attempts, _sleep, _attempt_no) do
    Logger.warn("[#{__MODULE__}] exhausted #{max_attempts} discovery attempts!")
    []
  end

  defp to_bridge(device) do
    %Bridge{host: device["internalipaddress"]}
  end
end
