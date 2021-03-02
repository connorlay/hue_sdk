defmodule HueSDK.Discovery.MDNS do
  @moduledoc """
  Automatic discovery for the Hue Bridge via mDNS.
  """

  @namespace "_hue._tcp.local"
  @max_attempts 10
  @sleep 3 * 1000

  require Logger

  @typedoc """
  The parsed JSON response, tagged by the discovery protocol.
  """
  @type mdns_result :: {:mdns, map() | nil}

  @doc """
  Attempts to discover any Hue Bridge devices on the local 
  network by querying the namespace '#{@namespace}'.

  Performs #{@max_attempts} attempts before giving up.
  """
  @spec discover() :: mdns_result()
  def discover(namespace \\ @namespace) do
    start_discovery(namespace)
    device = poll_for_discovery(namespace)
    stop_discovery(namespace)
    device
  end

  defp start_discovery(namespace) do
    Logger.debug("mDNS starting discovery for namespace '#{namespace}'")
    :ok = Mdns.Client.start()
  end

  defp poll_for_discovery(namespace), do: poll_for_discovery(namespace, 1)

  defp poll_for_discovery(namespace, attempt) when attempt < @max_attempts do
    Logger.debug("mDNS discovery attempt #{attempt}/#{@max_attempts}..")
    :ok = Mdns.Client.query(namespace)

    case Mdns.Client.devices()[:"#{namespace}"] do
      nil ->
        :timer.sleep(@sleep)
        poll_for_discovery(namespace, attempt + 1)

      [device] ->
        Logger.debug("mDNS discovered device #{inspect(device)}")
        {:mdns, device}

      [device | _devices] ->
        Logger.debug("mDNS discovered multiple devices, picking first #{inspect(device)}")
        {:mdns, device}
    end
  end

  defp poll_for_discovery(_namespace, _attempt), do: {:mdns, nil}

  defp stop_discovery(namespace) do
    Logger.debug("mDNS stopping discovery for namespace '#{namespace}'..")
    :ok = Mdns.Client.stop()
  end
end
