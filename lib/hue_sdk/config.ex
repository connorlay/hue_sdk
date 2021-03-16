defmodule HueSDK.Config do
  @moduledoc """
  Application configuration for the HueSDK.
  """

  @ssl true
  @portal_url "https://discovery.meethue.com/"

  @doc """
  Should SSL be used for requests made to the Hue Bridge? Defaults to `#{@ssl}`.

  ## Examples

      config :hue_sdk, ssl: #{@ssl}
  """
  def ssl? do
    Application.get_env(:hue_sdk, :ssl, @ssl)
  end

  @doc """
  The URL of the Hue Bridge discovery portal. Defaults to `#{@portal_url}`.

  ## Examples

      config :hue_sdk, portal_url: #{@portal_url}
  """
  def portal_url do
    Application.get_env(:hue_sdk, :portal_url, @portal_url)
  end
end
