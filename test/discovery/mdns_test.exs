defmodule HueSDK.Discovery.MDNSTest do
  alias HueSDK.Discovery.MDNS
  use ExUnit.Case, async: true

  @host_name "#{__MODULE__}.local"
  @server_ip {127, 0, 0, 1}

  test "discover/0" do
    host_service = %Mdns.Server.Service{
      domain: @host_name,
      data: :ip,
      ttl: 10,
      type: :a
    }

    tcp_service = %Mdns.Server.Service{
      domain: "_hue._tcp.local",
      data: "_hue._tcp.local",
      ttl: 10,
      type: :ptr
    }

    Mdns.Server.start()
    Mdns.Server.set_ip(@server_ip)
    Mdns.Server.add_service(host_service)
    Mdns.Server.add_service(tcp_service)

    assert {:mdns, device} = MDNS.discover()

    assert device == %Mdns.Client.Device{
             domain: @host_name,
             ip: {192, 168, 1, 13},
             payload: %{},
             services: ["_hue._tcp.local"]
           }
  end
end
