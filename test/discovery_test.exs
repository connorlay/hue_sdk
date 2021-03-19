defmodule HueSDK.DiscoveryTest do
  alias HueSDK.{Bridge, Discovery}

  import Mox

  use HueSDK.BypassCase, async: true

  # ensure Mox verifies interactions
  setup :verify_on_exit!

  describe "discover/2" do
    test "returns a full Bridge struct for each discovered device", %{
      bypass: bypass,
      bridge: bridge
    } do
      # setup MockDiscovery.do_discovery/1 to return a Bridge device
      expect(MockDiscovery, :do_discovery, 1, fn _opts ->
        {:mock, [bridge]}
      end)

      # setup config response for HueSDK.Configuration.get_bridge_config/1
      get(bypass, "/api/config", %{
        "apiversion" => "1.42.0",
        "bridgeid" => "ecb5fafffe1b6528",
        "datastoreversion" => "99",
        "mac" => "ec:b5:fa:1b:65:28",
        "modelid" => "BSB002",
        "name" => "Dung Dome Bridge",
        "swversion" => "1943082030"
      })

      # verify Bridge is returned with config data
      assert {:mock,
              [
                %Bridge{
                  api_version: "1.42.0",
                  bridge_id: "ecb5fafffe1b6528",
                  datastore_version: "99",
                  mac: "ec:b5:fa:1b:65:28",
                  model_id: "BSB002",
                  name: "Dung Dome Bridge",
                  sw_version: "1943082030"
                }
              ]} = Discovery.discover(MockDiscovery)
    end

    test "raises a NimbleOptions.ValidationError if opts fail validation" do
      # expect MockDiscovery.do_discovery/1 to never be called
      expect(MockDiscovery, :do_discovery, 0, fn _opts -> {:mock, []} end)

      # NimbleOptions should raise a schema validation error
      assert_raise NimbleOptions.ValidationError, fn ->
        Discovery.discover(MockDiscovery, invalid_opt: :invalid_opt)
      end
    end

    test "passes default opts to Discovery behaviour when none are supplied" do
      # validate default opts passed to MockDiscovery.do_discovery/1
      expect(MockDiscovery, :do_discovery, 1, fn opts ->
        assert "_hue._tcp.local" == opts[:mdns_namespace]
        assert 10 == opts[:max_attempts]
        assert 5000 == opts[:sleep]
        {:mock, []}
      end)

      # verify no Bridge structs are returned when no devices are discovered
      assert {:mock, []} == Discovery.discover(MockDiscovery)
    end
  end
end
