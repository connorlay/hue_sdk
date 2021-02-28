defmodule HueSDK.API.GroupsTest do
  alias HueSDK.API.Groups

  use HueSDK.APICase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_groups/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/groups", @json_resp)
      assert {:ok, @json_resp} == Groups.get_all_groups(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Groups.get_all_groups(bridge)
    end
  end

  describe "create_group/4" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(
        bypass,
        "/api/#{bridge.username}/groups",
        %{"name" => "group", "type" => "foo", "lights" => [1, 2]},
        @json_resp
      )

      assert {:ok, @json_resp} == Groups.create_group(bridge, "group", "foo", [1, 2])
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Groups.get_all_groups(bridge)
    end
  end

  describe "get_group_attributes/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/groups/1", @json_resp)
      assert {:ok, @json_resp} == Groups.get_group_attributes(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Groups.get_group_attributes(bridge, 1)
    end
  end

  describe "set_group_attributes/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/groups/1", %{}, @json_resp)
      assert {:ok, @json_resp} == Groups.set_group_attributes(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Groups.set_group_attributes(bridge, 1, %{})
    end
  end

  describe "set_group_state/3" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/groups/1/action", %{}, @json_resp)
      assert {:ok, @json_resp} == Groups.set_group_state(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Groups.set_group_attributes(bridge, 1, %{})
    end
  end

  describe "delete_group/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      delete(bypass, "/api/#{bridge.username}/groups/1", @json_resp)
      assert {:ok, @json_resp} == Groups.delete_group(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Groups.delete_group(bridge, 1)
    end
  end
end
