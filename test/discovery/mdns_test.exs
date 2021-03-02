defmodule HueSDK.Discovery.MDNSTest do
  alias HueSDK.Discovery.MDNS
  use ExUnit.Case, async: true

  @server_ip {127, 0, 0, 1}
  @namespace "_exunit._tcp.local"

  test "discover/0 returns found Mdns devices matching the supplied namespace" do
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

    Mdns.Server.start()
    Mdns.Server.set_ip(@server_ip)
    Mdns.Server.add_service(host_service)
    Mdns.Server.add_service(tcp_service)

    assert {:mdns, device} = MDNS.discover(@namespace)

    assert device == %Mdns.Client.Device{
             domain: @namespace,
             ip: {192, 168, 1, 13},
             payload: %{},
             services: [@namespace]
           }
  end
end
