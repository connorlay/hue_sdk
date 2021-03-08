defmodule HueSDK.Discovery.MDNS do
  @moduledoc """
  Automatic discovery for the Hue Bridge via mDNS.
  """

  require Logger

  @opts_schema [
    mdns_namespace: [
      doc: "The multicast DNS namespace to query.",
      type: :string,
      default: "_hue._tcp.local"
    ],
    max_attempts: [
      doc: "How many discovery attempts are made before giving up.",
      type: :pos_integer,
      default: 10
    ],
    sleep: [
      doc: "How long to wait in miliseconds between each attempt.",
      type: :pos_integer,
      default: 5000
    ]
  ]

  @typedoc """
  The parsed JSON response, tagged by the discovery protocol.
  """
  @type mdns_result :: {:mdns, map() | nil}

  @doc """
  Attempts to discover any Hue Bridge devices on the local network via multicast DNS.

  ### Options
  #{NimbleOptions.docs(@opts_schema)}
  """
  @spec discover(keyword()) :: mdns_result()
  def discover(opts \\ []) do
    vopts = NimbleOptions.validate!(opts, @opts_schema)

    start_discovery(vopts[:mdns_namespace])

    device =
      poll_for_discovery(
        vopts[:mdns_namespace],
        vopts[:max_attempts],
        vopts[:sleep]
      )

    stop_discovery(vopts[:namespace])
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
       when attempt_no <= max_attempts do
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
