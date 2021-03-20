defmodule HueSDK.API.Configuration do
  @moduledoc """
  Interface to the Configuration API.

  See the [official documentation](https://developers.meethue.com/develop/hue-api/7-configuration-api/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Returns list of all configuration elements in the bridge. Note all times are stored in UTC.
  """
  @spec get_bridge_config(Bridge.t()) :: HTTP.response()
  def get_bridge_config(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/config",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Allows the user to set some configuration values.
  """
  @spec modify_bridge_config(Bridge.t(), map()) :: HTTP.response()
  def modify_bridge_config(bridge, config) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/config",
      [],
      Jason.encode!(config),
      &Jason.decode!/1
    )
  end

  @doc """
  This command is used to fetch the entire datastore from the device, including settings and state information for lights, groups, schedules and configuration. It should only be used sparingly as it is resource intensive for the bridge, but is supplied e.g. for synchronization purposes.
  """
  @spec get_bridge_datastore(Bridge.t()) :: HTTP.response()
  def get_bridge_datastore(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Creates a new user. The link button on the bridge must be pressed and this command executed within 30 seconds.

  Once a new user has been created, the user key is added to a ‘whitelist’, allowing access to API commands that require a whitelisted user. At present, all other API commands require a whitelisted user.
  """
  @spec create_user(Bridge.t(), Bridge.devicetype()) :: HTTP.response()
  def create_user(bridge, device_type) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/",
      [],
      Jason.encode!(%{devicetype: device_type}),
      &Jason.decode!/1
    )
  end
end
