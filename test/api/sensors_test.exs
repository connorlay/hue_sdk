defmodule HueSDK.API.SensorsTest do
  alias HueSDK.API.Sensors
  alias HueSDK.JSON

  use HueSDK.APICase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_sensors/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/sensors", @json_resp)
      assert {:ok, @json_resp} == Sensors.get_all_sensors(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.get_all_sensors(bridge)
    end
  end

  describe "get_sensor_attributes/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/sensors/1", @json_resp)
      assert {:ok, @json_resp} == Sensors.get_sensor_attributes(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.get_sensor_attributes(bridge, 1)
    end
  end

  describe "create_sensor/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/sensors", %{}, @json_resp)
      assert {:ok, @json_resp} == Sensors.create_sensor(bridge, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.create_sensor(bridge, %{})
    end
  end

  describe "search_for_new_sensors/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      post(bypass, "/api/#{bridge.username}/sensors", nil, @json_resp)
      assert {:ok, @json_resp} == Sensors.search_for_new_sensors(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.search_for_new_sensors(bridge)
    end
  end

  describe "get_new_sensors/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/sensors/new", @json_resp)
      assert {:ok, @json_resp} == Sensors.get_new_sensors(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.get_new_sensors(bridge)
    end
  end

  describe "set_sensor_name/3" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/sensors/1", %{"name" => "foo"}, @json_resp)
      assert {:ok, @json_resp} == Sensors.set_sensor_name(bridge, 1, "foo")
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.set_sensor_name(bridge, 1, "foo")
    end
  end

  describe "set_sensor_attributes/3" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/sensors/1/config", %{}, @json_resp)
      assert {:ok, @json_resp} == Sensors.set_sensor_attributes(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.set_sensor_attributes(bridge, 1, %{})
    end
  end

  describe "set_sensor_state/3" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      put(bypass, "/api/#{bridge.username}/sensors/1/state", %{}, @json_resp)
      assert {:ok, @json_resp} == Sensors.set_sensor_state(bridge, 1, %{})
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.set_sensor_state(bridge, 1, %{})
    end
  end

  describe "delete_sensor/2" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      delete(bypass, "/api/#{bridge.username}/sensors/1", @json_resp)
      assert {:ok, @json_resp} == Sensors.delete_sensor(bridge, 1)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Sensors.delete_sensor(bridge, 1)
    end
  end
end
