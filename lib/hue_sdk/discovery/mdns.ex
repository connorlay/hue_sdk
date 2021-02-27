defmodule HueSDK.Discovery.MDNS do
  @moduledoc """
  Automatic discovery for the Hue Bridge via mDNS.
  """

  @namespace "_hue._tcp.local"
  @max_attempts 10
  @sleep 5 * 1000

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
  def discover() do
    start_discovery()
    device = poll_for_discovery()
    stop_discovery()
    device
  end

  defp start_discovery() do
    Logger.debug("mDNS starting discovery for namespace '#{@namespace}'")
    :ok = Mdns.Client.start()
  end

  defp poll_for_discovery(), do: poll_for_discovery(1)

  defp poll_for_discovery(attempt) when attempt < @max_attempts do
    Logger.debug("mDNS discovery attempt #{attempt}/#{@max_attempts}..")
    :ok = Mdns.Client.query(@namespace)

    case Mdns.Client.devices()[:"#{@namespace}"] do
      nil ->
        :timer.sleep(@sleep)
        poll_for_discovery(attempt + 1)

      [device] ->
        Logger.debug("mDNS discovered device #{inspect(device)}")
        {:mdns, device}

      [device | _devices] ->
        Logger.debug("mDNS discovered multiple devices, picking first #{inspect(device)}")
        {:mdns, device}
    end
  end

  defp poll_for_discovery(_attempt), do: {:mdns, nil}

  defp stop_discovery() do
    Logger.debug("mDNS stopping discovery for namespace '#{@namespace}'..")
    :ok = Mdns.Client.stop()
  end
end
