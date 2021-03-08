defmodule HueSDK.Discovery.NUPNP do
  @moduledoc """
  Automatic discovery for the Hue Bridge via N-UPnP.
  """

  alias HueSDK.{HTTP, JSON}

  require Logger

  @opts_schema [
    discovery_portal_url: [
      doc: "The URL of the Hue Bridge discovery portal.",
      type: :string,
      default: "https://discovery.meethue.com/"
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
  @type nupnp_result :: {:nupnp, map() | nil}

  @doc """
  Attempts to discover any Hue Bridge devices on the local
  network by querying the official Hue Bridge portal.

  ### Options
  #{NimbleOptions.docs(@opts_schema)}
  """
  @spec discover(keyword()) :: nupnp_result()
  def discover(opts \\ []) do
    vopts = NimbleOptions.validate!(opts, @opts_schema)

    poll_for_discovery(
      vopts[:discovery_portal_url],
      vopts[:max_attempts],
      vopts[:sleep]
    )
  end

  def default_discovery_portal_url, do: @opts_schema[:discovery_portal_url][:default]

  defp poll_for_discovery(discovery_portal_url, max_attempts, sleep) do
    poll_for_discovery(discovery_portal_url, max_attempts, sleep, 1)
  end

  defp poll_for_discovery(discovery_portal_url, max_attempts, sleep, attempt_no)
       when attempt_no <= max_attempts do
    Logger.debug("N-UPnP discovery attempt #{attempt_no}/#{max_attempts}..")

    case HTTP.request(:get, discovery_portal_url, [], nil, &JSON.decode!/1) do
      {:ok, [device]} ->
        Logger.debug("N-UPnP discovered device #{inspect(device)}")
        {:nupnp, device}

      {:ok, [device | _devices]} ->
        Logger.debug("N-UPnP discovered multiple devices, picking first #{inspect(device)}")
        {:nupnp, device}

      _ ->
        :timer.sleep(sleep)
        poll_for_discovery(discovery_portal_url, max_attempts, sleep, attempt_no + 1)
    end
  end

  defp poll_for_discovery(_namespace, _max_attempts, _sleep, _attempt_no) do
    {:nupnp, nil}
  end
end
