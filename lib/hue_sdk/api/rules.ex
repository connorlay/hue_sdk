defmodule HueSDK.API.Rules do
  @moduledoc """
  Interface to the Rules API

  See the [official documentation](https://developers.meethue.com/develop/hue-api/6-rules-api/) for more information.
  """

  alias HueSDK.{Bridge, HTTP}

  @doc """
  Gets a list of all rules that are in the bridge.
  """
  @spec get_all_rules(Bridge.t()) :: HTTP.response()
  def get_all_rules(bridge) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/rules",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Returns a rule object with id matching <id> or an error if <id> is not available.
  """
  @spec get_rule_attributes(Bridge.t(), String.t()) :: HTTP.response()
  def get_rule_attributes(bridge, rule_id) do
    HTTP.request(
      :get,
      "#{bridge.host}/api/#{bridge.username}/rules/#{rule_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end

  @doc """
  Creates a new rule in the bridge rule engine.
  """
  @spec create_rule(Bridge.t(), map()) :: HTTP.response()
  def create_rule(bridge, attributes) do
    HTTP.request(
      :post,
      "#{bridge.host}/api/#{bridge.username}/rules",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Updates a rule in the bridge rule engine.
  """
  @spec update_rule(Bridge.t(), String.t(), map()) :: HTTP.response()
  def update_rule(bridge, rule_id, attributes) do
    HTTP.request(
      :put,
      "#{bridge.host}/api/#{bridge.username}/rules/#{rule_id}",
      [],
      Jason.encode!(attributes),
      &Jason.decode!/1
    )
  end

  @doc """
  Deletes the specified rule from the bridge.
  """
  @spec delete_rule(Bridge.t(), String.t()) :: HTTP.response()
  def delete_rule(bridge, rule_id) do
    HTTP.request(
      :delete,
      "#{bridge.host}/api/#{bridge.username}/rules/#{rule_id}",
      [],
      nil,
      &Jason.decode!/1
    )
  end
end
