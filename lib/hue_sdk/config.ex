defmodule HueSDK.Config do
  @moduledoc """
  Application configuration available for `HueSDK`.
  """

  @ssl true
  @portal_host "discovery.meethue.com"

  @doc """
  Should SSL be used for requests made to the Hue Bridge? Defaults to `#{@ssl}`.

  Hue Bridge SSL certificates are self-signed. The first certificate received
  will be pinned and used to verify subsequent responses.

  ## Examples

  Enabling SSL for all requests made to the Hue Bridge:

      config :hue_sdk, ssl: true

  Disabling SSL for all requests made to the Hue Bridge:

      config :hue_sdk, ssl: false
  """
  @spec ssl?() :: boolean()
  def ssl? do
    Application.get_env(:hue_sdk, :ssl, @ssl)
  end

  @doc """
  The DNS host of the Hue Bridge discovery portal. Defaults to `#{@portal_host}`.

  ## Examples

  Configuring a custom host for `HueSDK.Discovery.NUPNP` requests:

      config :hue_sdk, portal_host: "#{@portal_host}"
  """
  @spec portal_host() :: String.t()
  def portal_host do
    Application.get_env(:hue_sdk, :portal_host, @portal_host)
  end
end
