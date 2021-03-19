defmodule HueSDK.Discovery.ManualIPTest do
  use ExUnit.Case, async: true

  alias HueSDK.Bridge
  alias HueSDK.Discovery.ManualIP

  @ip_address "127.0.0.1"

  test "do_discovery/1 returns a basic bridge struct" do
    assert {:manual_ip, [%Bridge{host: @ip_address}]} ==
             ManualIP.do_discovery(ip_address: @ip_address)
  end
end
