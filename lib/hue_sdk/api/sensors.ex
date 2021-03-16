defmodule HueSDK.API.Sensors do
  @moduledoc """
  Interface to the Sensors API
  https://developers.meethue.com/develop/hue-api/5-sensors-api/
  """

  alias HueSDK.HTTP

  @doc """
  Gets a list of all sensors that have been added to the bridge.
  """
  def get_all_sensors(bridge) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Gets the sensor from the bridge with the given id.
  """
  def get_sensor_attributes(bridge, sensor_id) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors/#{sensor_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Allows the creation of sensors.
  """
  def create_sensor(bridge, attributes) do
    HTTP.request(
      :post,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Starts a search for new sensors.
  """
  def search_for_new_sensors(bridge) do
    HTTP.request(
      :post,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Finds all new sensors since the last scan.
  """
  def get_new_sensors(bridge) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors/new",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Renames the sensor in the bridge for the supplied id.
  """
  def set_sensor_name(bridge, sensor_id, name) do
    HTTP.request(
      :put,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors/#{sensor_id}",
      [],
      Jason.encode!(%{name: name}),
      &Jason.decode!/1
    )
  end

  @doc """
  The allowed configuration parameters depend on the sensor type.
  """
  def set_sensor_attributes(bridge, sensor_id, attributes) do
    HTTP.request(
      :put,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors/#{sensor_id}/config",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Used to allow the state of a CLIP sensor to be updated.
  """
  def set_sensor_state(bridge, sensor_id, state) do
    HTTP.request(
      :put,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors/#{sensor_id}/state",
      [],
      Jason.encode!(state),
      &Jason.decode!/1
    )
  end

  @doc """
  All sensors can be deleted.
  """
  def delete_sensor(bridge, sensor_id) do
    HTTP.request(
      :delete,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/sensors/#{sensor_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
