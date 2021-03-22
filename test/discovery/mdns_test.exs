defmodule HueSDK.Discovery.MDNSTest do
  alias HueSDK.Bridge
  alias HueSDK.Discovery.MDNS

  use ExUnit.Case, async: true

  @server_ip {127, 0, 0, 1}
  @namespace "_exunit._tcp.local"

  setup_all do
    # start a local mDNS server
    Mdns.Server.start()
    Mdns.Server.set_ip(@server_ip)

    # add a new ip to the mDNS server
    Mdns.Server.add_service(%Mdns.Server.Service{
      domain: @namespace,
      data: :ip,
      ttl: 10,
      type: :a
    })

    # add a new device under the test namespace
    Mdns.Server.add_service(%Mdns.Server.Service{
      domain: @namespace,
      data: @namespace,
      ttl: 10,
      type: :ptr
    })

    # ensure the mDNS server stops when the test exits
    on_exit(&Mdns.Server.stop/0)
  end

  test "discover/0 returns the first found device matching the supplied namespace" do
    assert {:mdns, [%Bridge{host: _ip_address}]} =
             MDNS.do_discovery(mdns_namespace: @namespace, max_attempts: 10, sleep: 100)
  end

  test "discover/0 returns {:mdns, nil} if no devices are found" do
    namespace = "_i_don't_exist._tcp.local"
    assert {:mdns, []} = MDNS.do_discovery(mdns_namespace: namespace, max_attempts: 1, sleep: 1)
  end
end
