defmodule HueSDK.Discovery.NUPNPTest do
  alias HueSDK.Discovery.NUPNP

  use HueSDK.APICase

  test "discover/0", %{bypass: bypass} do
    bypass_url = "localhost:#{bypass.port}/"
    Application.put_env(:hue_sdk, :hue_portal_url, bypass_url)

    get(bypass, "/", [%{some: "device"}])
    assert {:nupnp, %{"some" => "device"}} = NUPNP.discover()

    get(bypass, "/", [%{some: "device"}, %{other: "device"}])
    assert {:nupnp, %{"some" => "device"}} = NUPNP.discover()

    get(bypass, "/", [])
    assert {:nupnp, nil} = NUPNP.discover()
  end
end
