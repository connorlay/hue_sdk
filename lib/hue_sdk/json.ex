defmodule HueSDK.JSON do
  @moduledoc """
  JSON parsing for the Hue SDK.

  Delegates to `Jason`.
  """

  defdelegate decode!(term), to: Jason

  defdelegate encode!(term), to: Jason
end
