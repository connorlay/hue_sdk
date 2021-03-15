defmodule HueSDK.Discovery.ManualIPTest do
  use ExUnit.Case, async: true

  alias HueSDK.Bridge
  alias HueSDK.Discovery.ManualIP

  test "do_discovery/1 returns a basic bridge struct" do
    ip_address = "127.0.0.1"

    assert {:manual_ip, [%Bridge{host: ip_address, scheme: :http}]} ==
             ManualIP.do_discovery(ip_address: ip_address)
  end
end
