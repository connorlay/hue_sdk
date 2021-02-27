defmodule HueSDK.API.CapabilitiesTest do
  alias HueSDK.API.Capabilities
  alias HueSDK.JSON

  use HueSDK.APICase, async: true

  @json_resp %{"1" => %{"name" => "example"}}
  @http_error %Mint.TransportError{reason: :econnrefused}

  describe "get_all_capabilities/1" do
    test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
      get(bypass, "/api/#{bridge.username}/capabilities", @json_resp)
      assert {:ok, @json_resp} == Capabilities.get_all_capabilities(bridge)
    end

    test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
      Bypass.down(bypass)
      assert {:error, @http_error} == Capabilities.get_all_capabilities(bridge)
    end
  end
end
