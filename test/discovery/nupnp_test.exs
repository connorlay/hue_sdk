defmodule HueSDK.Discovery.NUPNPTest do
  alias HueSDK.Discovery.NUPNP
  alias HueSDK.Bridge

  use HueSDK.APICase

  @discovery_opts [max_attempts: 3, sleep: 1]

  test "discover/0 returns the first found device", %{bypass: bypass} do
    get(bypass, "/", [%{id: "12345", internalipaddress: "000.0.0.0"}])

    assert {:nupnp, [%Bridge{bridge_id: "12345", host: "000.0.0.0"}]} =
             NUPNP.do_discovery(@discovery_opts)
  end

  test "discover/0 returns {:nupnp, []} if no devices are found", %{bypass: bypass} do
    get(bypass, "/", %{"error" => "some error"})

    assert {:nupnp, []} = NUPNP.do_discovery(@discovery_opts)
  end
end
