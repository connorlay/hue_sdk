defmodule HueSDK.API.Scenes do
  @moduledoc """
  Interface to the Scenes API
  https://developers.meethue.com/develop/hue-api/4-scenes/
  """

  alias HueSDK.{HTTP, JSON}

  @doc """
  Gets a list of all scenes currently stored in the bridge.
  """
  def get_all_scenes(bridge) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/scenes",
      [],
      nil,
      &JSON.decode!/1
    )
  end

  @doc """
  Gets the attributes of a given scene.
  """
  def get_scene_attributes(bridge, scene_id) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/scenes/#{scene_id}",
      [],
      nil,
      &JSON.decode!/1
    )
  end

  @doc """
  Creates the given scene with all lights in the provided lights resource.
  """
  def create_scene(bridge, attributes) do
    HTTP.request(
      :post,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/scenes",
      [],
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Modifies or creates a new scene.
  """
  def modify_scene(bridge, scene_id, attributes) do
    HTTP.request(
      :put,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/scenes/#{scene_id}/lightstates/#{scene_id}",
      [],
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Deletes a scene from the bridge.
  """
  def delete_scene(bridge, scene_id) do
    HTTP.request(
      :delete,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/scenes/#{scene_id}",
      [],
      nil,
      &JSON.decode!/1
    )
  end
end
