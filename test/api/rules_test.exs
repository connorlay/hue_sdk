defmodule HueSDK.RulesTest do
  alias HueSDK.API.Rules

  use HueSDK.APICase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_rules/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/rules", @json_resp)
      assert {:ok, @json_resp} == Rules.get_all_rules(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Rules.get_all_rules(bridge)
    end
  end

  describe "get_rule_attributes/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/rules/1", @json_resp)
      assert {:ok, @json_resp} == Rules.get_rule_attributes(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Rules.get_rule_attributes(bridge, 1)
    end
  end

  describe "create_rule/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/rules", %{}, @json_resp)
      assert {:ok, @json_resp} == Rules.create_rule(bridge, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Rules.create_rule(bridge, %{})
    end
  end

  describe "update_rule/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/rules/1", %{}, @json_resp)
      assert {:ok, @json_resp} == Rules.update_rule(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Rules.update_rule(bridge, 1, %{})
    end
  end

  describe "delete_rule/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      delete(bypass, "/api/#{bridge.username}/rules/1", @json_resp)
      assert {:ok, @json_resp} == Rules.delete_rule(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Rules.delete_rule(bridge, 1)
    end
  end
end
