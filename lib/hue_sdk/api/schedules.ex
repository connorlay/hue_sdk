defmodule HueSDK.API.Schedules do
  @moduledoc """
  Interface to the Schedules API
  https://developers.meethue.com/develop/hue-api/3-schedules-api/
  """

  alias HueSDK.{HTTP, JSON}

  @doc """
  Gets a list of all schedules that have been added to the bridge.
  """
  def get_all_schedules(bridge) do
    HTTP.request(
      :get,
      "http://#{bridge.host}/api/#{bridge.username}/schedules",
      &JSON.decode!/1
    )
  end

  @doc """
  Allows the user to create new schedules. The bridge can store up to 100 schedules.
  """
  def create_schedule(bridge, attributes) do
    HTTP.request(
      :post,
      "http://#{bridge.host}/api/#{bridge.username}/schedules",
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Gets all attributes for a schedule.
  """
  def get_schedule_attributes(bridge, schedule_id) do
    HTTP.request(
      :get,
      "http://#{bridge.host}/api/#{bridge.username}/schedules/#{schedule_id}",
      &JSON.decode!/1
    )
  end

  @doc """
  Allows the user to change attributes of a schedule.
  """
  def set_schedule_attributes(bridge, schedule_id, attributes) do
    HTTP.request(
      :put,
      "http://#{bridge.host}/api/#{bridge.username}/schedules/#{schedule_id}",
      JSON.encode!(attributes),
      &JSON.decode!/1
    )
  end

  @doc """
  Deletes a schedule from the bridge.
  """
  def delete_schedule(bridge, schedule_id) do
    HTTP.request(
      :delete,
      "http://#{bridge.host}/api/#{bridge.username}/schedules/#{schedule_id}",
      &JSON.decode!/1
    )
  end
end
