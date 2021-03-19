defmodule HueSDK.BridgeTest do
  alias HueSDK.Bridge

  use HueSDK.BypassCase, async: true

  @username "username"
  @devicetype "exunit"

  describe "authenticate/2" do
    test "creates a new user and adds it to the Bridge struct", %{bypass: bypass, bridge: bridge} do
      # setup user response for HueSDK.Configuration.create_user/2
      post(bypass, "/api/", %{"devicetype" => @devicetype}, [
        %{"success" => %{"username" => @username}}
      ])

      assert %{bridge | username: @username} == Bridge.authenticate(bridge, @devicetype)
    end

    test "returns the bridge with no user if there is an error", %{bypass: bypass, bridge: bridge} do
      # setup error response for HueSDK.Configuration.create_user/2
      post(bypass, "/api/", %{"devicetype" => @devicetype}, [
        %{"error" => %{"description" => "boom!"}}
      ])

      assert bridge == Bridge.authenticate(bridge, @devicetype)
    end

    test "returns the bridge with no user if the connection fails", %{
      bypass: bypass,
      bridge: bridge
    } do
      Bypass.down(bypass)
      assert bridge == Bridge.authenticate(bridge, @devicetype)
    end
  end
end
