defmodule HueSDK.API.Configuration do
  @moduledoc """
  Interface to the Configuration API
  https://developers.meethue.com/develop/hue-api/7-configuration-api/
  """

  alias HueSDK.{HTTP, JSON}

  @doc """
  Returns list of all configuration elements in the bridge. Note all times are stored in UTC.
  """
  def get_bridge_config(bridge) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/config",
      [],
      nil,
      &JSON.decode!/1
    )
  end

  @doc """
  Allows the user to set some configuration values.
  """
  def modify_bridge_config(bridge, config) do
    HTTP.request(
      :put,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}/config",
      [],
      JSON.encode!(config),
      &JSON.decode!/1
    )
  end

  @doc """
  This command is used to fetch the entire datastore from the device, including settings and state information for lights, groups, schedules and configuration. It should only be used sparingly as it is resource intensive for the bridge, but is supplied e.g. for synchronization purposes.
  """
  def get_bridge_datastore(bridge) do
    HTTP.request(
      :get,
      bridge.scheme,
      "#{bridge.host}/api/#{bridge.username}",
      [],
      nil,
      &JSON.decode!/1
    )
  end

  @doc """
  Creates a new user. The link button on the bridge must be pressed and this command executed within 30 seconds.

  Once a new user has been created, the user key is added to a ‘whitelist’, allowing access to API commands that require a whitelisted user. At present, all other API commands require a whitelisted user.
  """
  def create_user(bridge, device_type) do
    HTTP.request(
      :post,
      bridge.scheme,
      "#{bridge.host}/api/",
      [],
      JSON.encode!(%{devicetype: device_type}),
      &JSON.decode!/1
    )
  end
end
