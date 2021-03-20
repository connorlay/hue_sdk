defmodule HueSDK.Discovery.MDNS do
  @moduledoc """
  mDNS discovery of the Hue Bridge.

  See `HueSDK.Discovery` for available options.
  """

  alias HueSDK.{Bridge, Discovery}

  require Logger

  @behaviour Discovery

  @impl true
  def do_discovery(opts) do
    devices =
      poll_for_discovery(
        opts[:mdns_namespace],
        opts[:max_attempts],
        opts[:sleep]
      )

    {:mdns, Enum.map(devices, &to_bridge/1)}
  end

  defp poll_for_discovery(namespace, max_attempts, sleep) do
    :ok = Mdns.Client.start()
    poll_for_discovery(namespace, max_attempts, sleep, 1)
  end

  defp poll_for_discovery(namespace, max_attempts, sleep, attempt_no)
       when attempt_no <= max_attempts do
    Logger.debug("[#{__MODULE__}] discovery attempt #{attempt_no}/#{max_attempts}..")
    :ok = Mdns.Client.query(namespace)

    case Mdns.Client.devices()[:"#{namespace}"] do
      nil ->
        :timer.sleep(sleep)
        poll_for_discovery(namespace, max_attempts, sleep, attempt_no + 1)

      devices when is_list(devices) ->
        Logger.debug("[#{__MODULE__}] discovered devices #{inspect(devices)}")
        devices
    end
  end

  defp poll_for_discovery(_namespace, max_attempts, _sleep, _attempt_no) do
    Logger.warn("[#{__MODULE__}] exhausted #{max_attempts} discovery attempts!")
    :ok = Mdns.Client.stop()
    []
  end

  defp to_bridge(device) do
    %Bridge{host: ip_tuple_to_host(device.ip)}
  end

  defp ip_tuple_to_host({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
end
