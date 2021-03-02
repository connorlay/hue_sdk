defmodule HueSDK.API.SchedulesTest do
  alias HueSDK.API.Schedules

  use HueSDK.APICase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_schedules/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/schedules", @json_resp)
      assert {:ok, @json_resp} == Schedules.get_all_schedules(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Schedules.get_all_schedules(bridge)
    end
  end

  describe "get_schedule_attributes/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/schedules/1", @json_resp)
      assert {:ok, @json_resp} == Schedules.get_schedule_attributes(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Schedules.get_schedule_attributes(bridge, 1)
    end
  end

  describe "create_schedule/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/schedules", %{}, @json_resp)
      assert {:ok, @json_resp} == Schedules.create_schedule(bridge, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Schedules.create_schedule(bridge, %{})
    end
  end

  describe "set_schedule_attributes/3" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/schedules/1", %{}, @json_resp)
      assert {:ok, @json_resp} == Schedules.set_schedule_attributes(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Schedules.set_schedule_attributes(bridge, 1, %{})
    end
  end

  describe "delete_schedule/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      delete(bypass, "/api/#{bridge.username}/schedules/1", @json_resp)
      assert {:ok, @json_resp} == Schedules.delete_schedule(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Schedules.delete_schedule(bridge, 1)
    end
  end
end
