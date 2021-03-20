defmodule HueSDK.API.Lights do
  @moduledoc """
  Interface to the Lights API.

  See the [official documentation](https://developers.meethue.com/develop/hue-api/lights-api/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Gets a list of all lights that have been discovered by the bridge.
  """
  @spec get_all_lights(Bridge.t()) :: HTTP.response()
  def get_all_lights(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/lights",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Gets a list of lights that were discovered the last time a search for new lights was performed.
  The list of new lights is always deleted when a new search is started.
  """
  @spec get_new_lights(Bridge.t()) :: HTTP.response()
  def get_new_lights(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/lights/new",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Starts searching for new lights.

  The bridge will open the network for 40s. The overall search might take longer since the configuration of (multiple) new devices can take longer. If many devices are found the command will have to be issued a second time after discovery time has elapsed. If the command is received again during search the search will continue for at least an additional 40s.

  When the search has finished, new lights will be available using the get new lights command. In addition, the new lights will now be available by calling get all lights or by calling get group attributes on group 0. Group 0 is a special group that cannot be deleted and will always contain all lights known by the bridge.
  """
  @spec search_for_new_lights(Bridge.t()) :: HTTP.response()
  def search_for_new_lights(bridge) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/#{bridge.username}/lights",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Gets the attributes and state of a given light.
  """
  @spec get_light_attributes_and_state(Bridge.t(), String.t()) :: HTTP.response()
  def get_light_attributes_and_state(bridge, light_id) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/lights/#{light_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Used to rename lights.
  A light can have its name changed when in any state, including when it is unreachable or off.
  """
  @spec set_light_name(Bridge.t(), String.t(), String.t()) :: HTTP.response()
  def set_light_name(bridge, light_id, name) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/lights/#{light_id}",
      [],
      Jason.encode!(%{name: name}),
      &Jason.decode!/1
    )
  end

  @doc """
  Allows the user to turn the light on and off, modify the hue and effects.
  """
  @spec set_light_state(Bridge.t(), String.t(), map()) :: HTTP.response()
  def set_light_state(bridge, id, state) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/lights/#{id}/state",
      [],
      Jason.encode!(state),
      &Jason.decode!/1
    )
  end

  @doc """
  Deletes a light from the bridge.
  """
  @spec delete_light(Bridge.t(), String.t()) :: HTTP.response()
  def delete_light(bridge, id) do
    HTTP.request(
      :delete,
      "#{bridge.host}/api/#{bridge.username}/lights/#{id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
