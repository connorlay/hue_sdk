defmodule HueSDK.Discovery.MDNSTest do
  alias HueSDK.Discovery.MDNS
  use ExUnit.Case, async: true

  @server_ip {127, 0, 0, 1}
  @namespace "_exunit._tcp.local"
  @bridge_id "12345"

  test "discover/0 returns the first found device matching the supplied namespace" do
    host_service = %Mdns.Server.Service{
      domain: @namespace,
      data: :ip,
      ttl: 10,
      type: :a
    }

    tcp_service = %Mdns.Server.Service{
      domain: @namespace,
      data: @namespace,
      ttl: 10,
      type: :ptr
    }

    txt_service = %Mdns.Server.Service{
      domain: @namespace,
      data: ["bridgeid=#{@bridge_id}"],
      ttl: 10,
      type: :txt
    }

    Mdns.Server.start()
    Mdns.Server.set_ip(@server_ip)
    Mdns.Server.add_service(host_service)
    Mdns.Server.add_service(tcp_service)
    Mdns.Server.add_service(txt_service)

    assert {:mdns, device} = MDNS.discover(mdns_namespace: @namespace)

    assert device == %Mdns.Client.Device{
             domain: @namespace,
             ip: {192, 168, 1, 13},
             payload: %{"bridgeid" => @bridge_id},
             services: [@namespace]
           }

    Mdns.Server.stop()
  end

  test "discover/0 returns {:mdns, nil} if no devices are found" do
    assert {:mdns, nil} = MDNS.discover(mdns_namespace: "_i_don't_exist._tcp.local", max_attempts: 1, sleep: 1)
  end
end
