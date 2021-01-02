defmodule HueSDK.Discovery.NUPNP do
  @moduledoc """
  Automatic discovery for the Hue Bridge via N-UPnP
  """

  alias HueSDK.HTTP

  require Logger

  @hue_portal_url "https://discovery.meethue.com/"

  @doc """
  Attempts to discover any Hue Bridge devices on the local
  network by querying the official Hue Bridge portal at '#{@hue_portal_url}'
  """
  def discover() do
    case HTTP.request(:get, @hue_portal_url, &Jason.decode!/1) do
      {:ok, [device]} ->
        Logger.debug("N-UPnP discovered device #{inspect(device)}")
        {:nupnp, device}

      {:ok, [device | _devices]} ->
        Logger.debug("N-UPnP discovered multiple devices, picking first #{inspect(device)}")
        {:nupnp, device}

      {:error, _mint_error} ->
        {:nupnp, nil}
    end
  end
end
