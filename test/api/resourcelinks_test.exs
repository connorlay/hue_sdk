defmodule HueSDK.ResourcelinksTest do
  alias HueSDK.API.Resourcelinks

  use HueSDK.BypassCase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_resourcelinks/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/resourcelinks", @json_resp)
      assert {:ok, @json_resp} == Resourcelinks.get_all_resourcelinks(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Resourcelinks.get_all_resourcelinks(bridge)
    end
  end

  describe "create_resourcelink/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/resourcelinks", %{}, @json_resp)
      assert {:ok, @json_resp} == Resourcelinks.create_resourcelink(bridge, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Resourcelinks.create_resourcelink(bridge, %{})
    end
  end

  describe "update_resourcelink/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/resourcelinks/1", %{}, @json_resp)
      assert {:ok, @json_resp} == Resourcelinks.update_resourcelink(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Resourcelinks.update_resourcelink(bridge, 1, %{})
    end
  end

  describe "delete_resourcelink/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      delete(bypass, "/api/#{bridge.username}/resourcelinks/1", @json_resp)
      assert {:ok, @json_resp} == Resourcelinks.delete_resourcelink(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Resourcelinks.delete_resourcelink(bridge, 1)
    end
  end
end
