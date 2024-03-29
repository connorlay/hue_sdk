defmodule HueSDK.API.Resourcelinks do
  @moduledoc """
  Interface to the Resourcelinks API.

  See the [official documentation](https://developers.meethue.com/develop/hue-api/9-resourcelinks-api/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Gets a list of all resourcelinks that are in the bridge.
  """
  @spec get_all_resourcelinks(Bridge.t()) :: HTTP.response()
  def get_all_resourcelinks(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Creates a new resourcelink in the bridge and generates a unique identifier for this resourcelink.
  """
  @spec create_resourcelink(Bridge.t(), map()) :: HTTP.response()
  def create_resourcelink(bridge, attributes) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Updates individual or multiple attributes of an existing resourcelink. At least one attribute has to be provided.
  """
  @spec update_resourcelink(Bridge.t(), String.t(), map()) :: HTTP.response()
  def update_resourcelink(bridge, resourcelink_id, attributes) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks/#{resourcelink_id}",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Deletes the specified resourcelink from the bridge.
  """
  @spec delete_resourcelink(Bridge.t(), String.t()) :: HTTP.response()
  def delete_resourcelink(bridge, resourcelink_id) do
    HTTP.request(
      :delete,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks/#{resourcelink_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
