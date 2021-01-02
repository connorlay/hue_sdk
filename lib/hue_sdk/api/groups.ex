defmodule HueSDK.API.Groups do
  @moduledoc """
  Interface to the Groups API
  https://developers.meethue.com/develop/hue-api/groups-api/
  """

  alias HueSDK.{HTTP, JSON}

  @doc """
  Gets a list of all groups that have been added to the bridge. A group is a list of lights that can be created, modified and deleted by a user.
  """
  def get_all_groups(bridge) do
    HTTP.request(
      :get,
      "http://#{bridge.host}/api/#{bridge.username}/groups",
      &JSON.decode!/1
    )
  end

  @doc """
  Creates a new group containing the lights specified and optional name. A new group is created in the bridge with the next available id.
  """
  def create_group(bridge, name, type, light_ids) do
    HTTP.request(
      :post,
      "http://#{bridge.host}/api/#{bridge.username}/groups",
      JSON.encode!(%{lights: light_ids, name: name, type: type}),
      &JSON.decode!/1
    )
  end

  @doc """
  Gets the group attributes, e.g. name, light membership and last command for a given group.
  """
  def get_group_attributes(bridge, group_id) do
    HTTP.request(
      :get,
      "http://#{bridge.host}/api/#{bridge.username}/groups/#{group_id}",
      &JSON.decode!/1
    )
  end

  @doc """
  Allows the user to modify the name, light and class membership of a group.
  """
  def set_group_attributes(bridge, group_id, attributes) do
    HTTP.request(
      :put,
      "http://#{bridge.host}/api/#{bridge.username}/groups/#{group_id}",
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Modifies the state of all lights in a group.
  """
  def set_group_state(bridge, group_id, state) do
    HTTP.request(
      :put,
      "http://#{bridge.host}/api/#{bridge.username}/groups/#{group_id}/action",
      JSON.encode!(state),
      &JSON.decode!/1
    )
  end

  @doc """
  Deletes the specified group from the bridge.  
  """
  def delete_group(bridge, group_id) do
    HTTP.request(
      :delete,
      "http://#{bridge.host}/api/#{bridge.username}/groups/#{group_id}",
      &JSON.decode!/1
    )
  end
end
