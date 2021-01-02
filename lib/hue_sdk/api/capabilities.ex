defmodule HueSDK.API.Capabilities do
  @moduledoc """
  Interface to the Capabilities API
  https://developers.meethue.com/develop/hue-api/10-capabilities-api/
  """

  alias HueSDK.HTTP

  @doc """
  Allows the user to list capabilities of resources supported in the bridge.
  """
  def get_all_capabilities(bridge) do
    HTTP.request(
      :get,
      "http://#{bridge.host}/api/#{bridge.username}/capabilities",
      &Jason.decode!/1
    )
  end
end
