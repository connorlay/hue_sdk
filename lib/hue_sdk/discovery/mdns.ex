defmodule HueSDK.Discovery.MDNS do
  @moduledoc """
  Automatic discovery for the Hue Bridge via mDNS.
  """

  @default_opts [
    namespace: "_hue._tcp.local",
    max_attempts: 10,
    sleep: 3 * 1000
  ]

  require Logger

  @typedoc """
  The parsed JSON response, tagged by the discovery protocol.
  """
  @type mdns_result :: {:mdns, map() | nil}

  @doc """
  Attempts to discover any Hue Bridge devices on the local 
  network via multicast DNS.
  """
  @spec discover(keyword()) :: mdns_result()
  def discover(opts \\ []) do
    all_opts = Keyword.merge(@default_opts, opts)
    start_discovery(all_opts[:namespace])
    device = poll_for_discovery(all_opts[:namespace], all_opts[:max_attempts], all_opts[:sleep])
    stop_discovery(all_opts[:namespace])
    device
  end

  defp start_discovery(namespace) do
    Logger.debug("mDNS starting discovery for namespace '#{namespace}'")
    :ok = Mdns.Client.start()
  end

  defp poll_for_discovery(namespace, max_attempts, sleep) do
    poll_for_discovery(namespace, max_attempts, sleep, 1)
  end

  defp poll_for_discovery(namespace, max_attempts, sleep, attempt_no)
       when attempt_no < max_attempts do
    Logger.debug("mDNS discovery attempt #{attempt_no}/#{max_attempts}..")
    :ok = Mdns.Client.query(namespace)

    case Mdns.Client.devices()[:"#{namespace}"] do
      nil ->
        :timer.sleep(sleep)
        poll_for_discovery(namespace, max_attempts, sleep, attempt_no + 1)

      [device] ->
        Logger.debug("mDNS discovered device #{inspect(device)}")
        {:mdns, device}

      [device | _devices] ->
        Logger.debug("mDNS discovered multiple devices, picking first #{inspect(device)}")
        {:mdns, device}
    end
  end

  defp poll_for_discovery(_namespace, _max_attempts, _sleep, _attempt_no) do
    {:mdns, nil}
  end

  defp stop_discovery(namespace) do
    Logger.debug("mDNS stopping discovery for namespace '#{namespace}'..")
    :ok = Mdns.Client.stop()
  end
end
