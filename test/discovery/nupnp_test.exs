defmodule HueSDK.Discovery.NUPNPTest do
  alias HueSDK.Discovery.NUPNP
  alias HueSDK.Bridge

  use HueSDK.BypassCase, async: true

  @discovery_opts [max_attempts: 3, sleep: 1]

  setup %{bypass: bypass} do
    # configure discovery portal to point to bypass server
    Application.put_env(:hue_sdk, :portal_host, "localhost:#{bypass.port}")
  end

  test "discover/0 returns the first found device", %{bypass: bypass} do
    get(bypass, "/", [%{"id" => "12345", "internalipaddress" => "000.0.0.0"}])
    assert {:nupnp, [%Bridge{host: "000.0.0.0"}]} == NUPNP.do_discovery(@discovery_opts)
  end

  test "discover/0 returns {:nupnp, []} if no devices are found", %{bypass: bypass} do
    get(bypass, "/", %{"error" => "some error"})
    assert {:nupnp, []} = NUPNP.do_discovery(@discovery_opts)
  end
end
