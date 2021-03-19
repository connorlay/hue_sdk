defmodule HueSDK.ScenesTest do
  alias HueSDK.API.Scenes

  use HueSDK.BypassCase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_scenes/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/scenes", @json_resp)
      assert {:ok, @json_resp} == Scenes.get_all_scenes(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Scenes.get_all_scenes(bridge)
    end
  end

  describe "get_scene_attributes/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/scenes/1", @json_resp)
      assert {:ok, @json_resp} == Scenes.get_scene_attributes(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Scenes.get_scene_attributes(bridge, 1)
    end
  end

  describe "create_scene/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/scenes", %{}, @json_resp)
      assert {:ok, @json_resp} == Scenes.create_scene(bridge, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Scenes.create_scene(bridge, %{})
    end
  end

  describe "modify_scene/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/scenes/1/lightstates/1", %{}, @json_resp)
      assert {:ok, @json_resp} == Scenes.modify_scene(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Scenes.modify_scene(bridge, 1, %{})
    end
  end

  describe "delete_scene/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      delete(bypass, "/api/#{bridge.username}/scenes/1", @json_resp)
      assert {:ok, @json_resp} == Scenes.delete_scene(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Scenes.delete_scene(bridge, 1)
    end
  end
end
