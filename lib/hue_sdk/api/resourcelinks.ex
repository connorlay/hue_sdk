defmodule HueSDK.API.Resourcelinks do
  @moduledoc """
  Interface to the Resourcelinks API
  https://developers.meethue.com/develop/hue-api/9-resourcelinks-api/
  """

  alias HueSDK.{HTTP, JSON}

  @doc """
  Gets a list of all resourcelinks that are in the bridge.
  """
  def get_all_resourcelinks(bridge) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks",
      [],
      nil,
      &JSON.decode!/1
    )
  end

  @doc """
  Creates a new resourcelink in the bridge and generates a unique identifier for this resourcelink.
  """
  def create_resourcelink(bridge, attributes) do
    HTTP.request(
      :post,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks",
      [],
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Updates individual or multiple attributes of an existing resourcelink. At least one attribute has to be provided.
  """
  def update_resourcelink(bridge, resourcelink_id, attributes) do
    HTTP.request(
      :put,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks/#{resourcelink_id}",
      [],
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Deletes the specified resourcelink from the bridge.
  """
  def delete_resourcelink(bridge, resourcelink_id) do
    HTTP.request(
      :delete,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/resourcelinks/#{resourcelink_id}",
      [],
      nil,
      &JSON.decode!/1
    )
  end
end
