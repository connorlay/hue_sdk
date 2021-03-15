defmodule HueSDK.Config do
  @moduledoc """
  Applicaton configuration for the HueSDK.
  """

  @bridge_ssl false
  @portal_url "https://discovery.meethue.com/"

  @doc """
  Should SSL be used for requests made to the Hue Bridge? Defaults to `#{@bridge_ssl}`.

  ## Examples

      config :hue_sdk, :ssl, true
  """
  def bridge_ssl? do
    Application.get_env(:hue_sdk, :bridge_ssl, @bridge_ssl)
  end

  @doc """
  The scheme used for requests made to the Hue Bridge.

  See `bridge_ssl?/0`.
  """
  def bridge_scheme do
    if bridge_ssl?() do
      :https
    else
      :http
    end
  end

  @doc """
  The URL of the Hue Bridge discovery portal. Defaults to `#{@portal_url}`.

  ## Examples

      config :hue_sdk, :portal_url, "https://my-custom-portal.com"
  """
  def hue_portal_url do
    Application.get_env(:hue_sdk, :portal_url, @portal_url)
  end
end
