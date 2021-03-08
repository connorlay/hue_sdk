defmodule HueSDK.Discovery.NUPNPTest do
  alias HueSDK.Discovery.NUPNP

  use HueSDK.APICase

  test "discover/0 returns the first found device", %{bypass: bypass} do
    discovery_portal_url = "localhost:#{bypass.port}/"

    get(bypass, "/", [%{some: "device"}])

    assert {:nupnp, %{"some" => "device"}} =
             NUPNP.discover(discovery_portal_url: discovery_portal_url)

    get(bypass, "/", [%{some: "device"}, %{other: "device"}])

    assert {:nupnp, %{"some" => "device"}} =
             NUPNP.discover(discovery_portal_url: discovery_portal_url)
  end

  test "discover/0 returns {:nupnp, nil} if no devices are found", %{bypass: bypass} do
    discovery_portal_url = "localhost:#{bypass.port}/"

    get(bypass, "/", [])

    assert {:nupnp, nil} =
             NUPNP.discover(discovery_portal_url: discovery_portal_url, max_attempts: 1, sleep: 1)
  end
end
