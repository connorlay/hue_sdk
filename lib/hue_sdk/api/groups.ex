defmodule HueSDK.API.Groups do
  @moduledoc """
  Interface to the Groups API.

  See the [official documentation](https://developers.meethue.com/develop/hue-api/groups-api/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Gets a list of all groups that have been added to the bridge. A group is a list of lights that can be created, modified and deleted by a user.
  """
  @spec get_all_groups(Bridge.t()) :: HTTP.response()
  def get_all_groups(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/groups",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Creates a new group containing the lights specified and optional name. A new group is created in the bridge with the next available id.
  """
  @spec create_group(Bridge.t(), String.t(), String.t(), [String.t()]) :: HTTP.response()
  def create_group(bridge, name, type, light_ids) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/#{bridge.username}/groups",
      [],
      Jason.encode!(%{lights: light_ids, name: name, type: type}),
      &Jason.decode!/1
    )
  end

  @doc """
  Gets the group attributes, e.g. name, light membership and last command for a given group.
  """
  @spec get_group_attributes(Bridge.t(), String.t()) :: HTTP.response()
  def get_group_attributes(bridge, group_id) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/groups/#{group_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Allows the user to modify the name, light and class membership of a group.
  """
  @spec set_group_attributes(Bridge.t(), String.t(), map()) :: HTTP.response()
  def set_group_attributes(bridge, group_id, attributes) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/groups/#{group_id}",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Modifies the state of all lights in a group.
  """
  @spec set_group_state(Bridge.t(), String.t(), map()) :: HTTP.response()
  def set_group_state(bridge, group_id, state) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/groups/#{group_id}/action",
      [],
      Jason.encode!(state),
      &Jason.decode!/1
    )
  end

  @doc """
  Deletes the specified group from the bridge.  
  """
  @spec delete_group(Bridge.t(), String.t()) :: HTTP.response()
  def delete_group(bridge, group_id) do
    HTTP.request(
      :delete,
      "#{bridge.host}/api/#{bridge.username}/groups/#{group_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
