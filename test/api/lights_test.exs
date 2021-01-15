defmodule HueSDK.API.LightsTest do
  alias HueSDK.API.Lights
  alias HueSDK.JSON

  use HueSDK.APICase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_lights/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/lights", @json_resp)
      assert {:ok, @json_resp} == Lights.get_all_lights(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Lights.get_all_lights(bridge)
    end
  end

  describe "get_new_lights/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/lights/new", @json_resp)
      assert {:ok, @json_resp} == Lights.get_new_lights(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Lights.get_new_lights(bridge)
    end
  end

  describe "search_for_new_lights/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/lights", nil, @json_resp)
      assert {:ok, @json_resp} == Lights.search_for_new_lights(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Lights.search_for_new_lights(bridge)
    end
  end

  describe "get_light_attributes_and_state/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/lights/1", @json_resp)
      assert {:ok, @json_resp} == Lights.get_light_attributes_and_state(bridge, "1")
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Lights.get_light_attributes_and_state(bridge, "1")
    end
  end
end
