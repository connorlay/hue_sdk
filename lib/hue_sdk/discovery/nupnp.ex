defmodule HueSDK.Discovery.NUPNP do
  @moduledoc """
  Automatic discovery for the Hue Bridge via N-UPnP.
  """

  alias HueSDK.{HTTP, JSON}

  require Logger

  @hue_portal_url "https://discovery.meethue.com/"

  @typedoc """
  The URL queried during discovery.

  Must include the scheme, e.g. '#{@hue_portal_url}'
  """
  @type hue_portal_url :: String.t()

  @typedoc """
  The parsed JSON response, tagged by the discovery protocol.
  """
  @type nupnp_result :: {:nupnp, map() | nil}

  @doc """
  Returns the configured URL for N-UPnP discovery.

  Unless otherwise configured, defaults to '#{@hue_portal_url}'.
  """
  @spec url() :: hue_portal_url()
  def url() do
    Application.get_env(:hue_sdk, :hue_portal_url, @hue_portal_url)
  end

  @doc """
  Attempts to discover any Hue Bridge devices on the local
  network by querying the official Hue Bridge portal.

  See `HueSDK.Discovery.NUPNP.url/0` for the url.
  """
  @spec discover() :: nupnp_result()
  def discover() do
    case HTTP.request(:get, url(), [], nil, &JSON.decode!/1) do
      {:ok, [device]} ->
        Logger.debug("N-UPnP discovered device #{inspect(device)}")
        {:nupnp, device}

      {:ok, [device | _devices]} ->
        Logger.debug("N-UPnP discovered multiple devices, picking first #{inspect(device)}")
        {:nupnp, device}

      _ ->
        {:nupnp, nil}
    end
  end
end
