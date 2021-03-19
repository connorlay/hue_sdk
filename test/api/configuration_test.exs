defmodule HueSDK.API.ConfigurationTest do
  alias HueSDK.API.Configuration

  use HueSDK.BypassCase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_bridge_config/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/config", @json_resp)
      assert {:ok, @json_resp} == Configuration.get_bridge_config(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Configuration.get_bridge_config(bridge)
    end
  end

  describe "modify_bridge_config/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/config", %{}, @json_resp)
      assert {:ok, @json_resp} == Configuration.modify_bridge_config(bridge, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Configuration.modify_bridge_config(bridge, %{})
    end
  end

  describe "get_bridge_datastore/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}", @json_resp)
      assert {:ok, @json_resp} == Configuration.get_bridge_datastore(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Configuration.get_bridge_datastore(bridge)
    end
  end

  describe "create_user/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/", %{"devicetype" => "exunit"}, @json_resp)
      assert {:ok, @json_resp} == Configuration.create_user(bridge, "exunit")
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Configuration.create_user(bridge, "exunit")
    end
  end
end
