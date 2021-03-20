defmodule HueSDK.API.Capabilities do
  @moduledoc """
  Interface to the Hue Bridge Capabilities API.

  See the [official documentation](https://developers.meethue.com/develop/hue-api/10-capabilities-api/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Allows the user to list capabilities of resources supported in the bridge.
  """
  @spec get_all_capabilities(Bridge.t()) :: HTTP.response()
  def get_all_capabilities(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/capabilities",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
