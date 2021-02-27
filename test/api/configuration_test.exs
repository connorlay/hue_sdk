defmodule HueSDK.API.ConfigurationTest do
  alias HueSDK.API.Configuration
  alias HueSDK.JSON

  use HueSDK.APICase, async: true

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
end
