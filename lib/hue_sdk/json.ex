defmodule HueSDK.JSON do
  @moduledoc false

  @doc false
  def decode!(term), do: Jason.decode!(term)

  @doc false
  def encode!(term), do: Jason.encode!(term)
end
