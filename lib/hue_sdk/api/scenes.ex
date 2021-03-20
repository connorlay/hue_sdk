defmodule HueSDK.API.Scenes do
  @moduledoc """
  Interface to the Scenes API.

  See the [official documentation](https://developers.meethue.com/develop/hue-api/4-scenes/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Gets a list of all scenes currently stored in the bridge.
  """
  @spec get_all_scenes(Bridge.t()) :: HTTP.response()
  def get_all_scenes(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/scenes",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Gets the attributes of a given scene.
  """
  @spec get_scene_attributes(Bridge.t(), String.t()) :: HTTP.response()
  def get_scene_attributes(bridge, scene_id) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/scenes/#{scene_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Creates the given scene with all lights in the provided lights resource.
  """
  @spec create_scene(Bridge.t(), map()) :: HTTP.response()
  def create_scene(bridge, attributes) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/#{bridge.username}/scenes",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Modifies or creates a new scene.
  """
  @spec modify_scene(Bridge.t(), String.t(), map()) :: HTTP.response()
  def modify_scene(bridge, scene_id, attributes) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/scenes/#{scene_id}/lightstates/#{scene_id}",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Deletes a scene from the bridge.
  """
  @spec delete_scene(Bridge.t(), String.t()) :: HTTP.response()
  def delete_scene(bridge, scene_id) do
    HTTP.request(
      :delete,
      "#{bridge.host}/api/#{bridge.username}/scenes/#{scene_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
