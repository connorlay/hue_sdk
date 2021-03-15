defmodule HueSDK.Discovery.MDNS do
  @moduledoc """
  mDNS discovery of the Hue Bridge.
  """

  alias HueSDK.{Config, Discovery}

  require Logger

  @behaviour Discovery

  @impl true
  def do_discovery(opts) do
    start_discovery(opts[:mdns_namespace])

    devices =
      poll_for_discovery(
        opts[:mdns_namespace],
        opts[:max_attempts],
        opts[:sleep]
      )

    stop_discovery(opts[:mdns_namespace])

    {:mdns, Enum.map(devices, &to_bridge/1)}
  end

  defp start_discovery(namespace) do
    Logger.debug("mDNS starting discovery for namespace '#{namespace}'")
    :ok = Mdns.Client.start()
  end

  defp poll_for_discovery(namespace, max_attempts, sleep) do
    poll_for_discovery(namespace, max_attempts, sleep, 1)
  end

  defp poll_for_discovery(namespace, max_attempts, sleep, attempt_no)
       when attempt_no <= max_attempts do
    Logger.debug("mDNS discovery attempt #{attempt_no}/#{max_attempts}..")
    :ok = Mdns.Client.query(namespace)

    case Mdns.Client.devices()[:"#{namespace}"] do
      nil ->
        :timer.sleep(sleep)
        poll_for_discovery(namespace, max_attempts, sleep, attempt_no + 1)

      devices when is_list(devices) ->
        Logger.debug("mDNS discovered devices #{inspect(devices)}")
        devices
    end
  end

  defp poll_for_discovery(_namespace, _max_attempts, _sleep, _attempt_no) do
    []
  end

  defp stop_discovery(namespace) do
    Logger.debug("mDNS stopping discovery for namespace '#{namespace}'..")
    :ok = Mdns.Client.stop()
  end

  defp to_bridge(device) do
    %HueSDK.Bridge{
      host: ip_tuple_to_host(device.ip),
      bridge_id: device.payload["bridgeid"],
      scheme: Config.bridge_scheme()
    }
  end

  defp ip_tuple_to_host({a, b, c, d}), do: "#{a}.#{b}.#{c}.#{d}"
end
