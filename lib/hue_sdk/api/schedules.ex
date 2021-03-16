defmodule HueSDK.API.Schedules do
  @moduledoc """
  Interface to the Schedules API
  https://developers.meethue.com/develop/hue-api/3-schedules-api/
  """

  alias HueSDK.HTTP

  @doc """
  Gets a list of all schedules that have been added to the bridge.
  """
  def get_all_schedules(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/schedules",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Gets all attributes for a schedule.
  """
  def get_schedule_attributes(bridge, schedule_id) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/schedules/#{schedule_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Allows the user to create new schedules. The bridge can store up to 100 schedules.
  """
  def create_schedule(bridge, attributes) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/#{bridge.username}/schedules",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Allows the user to change attributes of a schedule.
  """
  def set_schedule_attributes(bridge, schedule_id, attributes) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/schedules/#{schedule_id}",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Deletes a schedule from the bridge.
  """
  def delete_schedule(bridge, schedule_id) do
    HTTP.request(
      :delete,
      "#{bridge.host}/api/#{bridge.username}/schedules/#{schedule_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
