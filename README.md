# Elixir Hue SDK 💡

<!-- MDOC !-->

An unofficial Elixir SDK for the Philips Hue personal wireless lightning system.

Build with `Finch`, `Jason`, `Mdns`, and `NimbleOptions`.

## Features

`HueSDK` ships with the following features:

- Automatic discovery of the Hue Bridge device on local networks
- Complete support of the latest Hue Bridge JSON REST API
- SSL support for requests made to the Hue Bridge device

### Automatic Bridge Discovery

`HueSDK` supports [automatic bridge discovery](https://developers.meethue.com/develop/application-design-guidance/hue-bridge-discovery/) via the following protocols:

- N-UPnP
- mDNS
- Manual IP

If you have already connected your Hue Bridge device to the internet and registered online with Philips, then N-UPnP will be the fastest and most reliable way to discover your device.

If you do not wish to connect your Hue Bridge device to the internet or register it with Philips, then mDNS can be used to discover your device.

If neither of those protocols work, you can manually enter the IP address of your Hue Bridge device via the Manual IP protocol. Consult your home router to identify the device's IP address.

### REST API

`HueSDK` supports the following resources:

- [Lights](https://developers.meethue.com/develop/hue-api/lights-api/)
- [Groups](https://developers.meethue.com/develop/hue-api/groupds-api/)
- [Schedules](https://developers.meethue.com/develop/hue-api/3-schedules-api/)
- [Scenes](https://developers.meethue.com/develop/hue-api/4-scenes/)
- [Sensors](https://developers.meethue.com/develop/hue-api/5-sensors-api/)
- [Rules](https://developers.meethue.com/develop/hue-api/6-rules-api/)
- [Configuration](https://developers.meethue.com/develop/hue-api/7-configuration-api/)
- [Resourcelinks](https://developers.meethue.com/develop/hue-api/9-resourcelinks-api/)
- [Capabilities](https://developers.meethue.com/develop/hue-api/10-capabilities-api/)

Currently, this library provides a simple Elixir wrapper over the Hue Bridge REST API. Please refer to the [official documentation](https://developers.meethue.com/develop/hue-api/) for detailed information on interacting with lights, groups, schedules, etc.

High-level Elixir APIs may be added in future versions. If you have any you would like implemented, please open an issue or pull-request!

## Installation

Add the Hue SDK to your `mix.exs` and run `mix deps.get`:

```elixir
def deps do
  [
    {:hue_sdk, "~> 0.1.0"}
  ]
end
```

Add any optional configuration to your `config/*.exs` files:

```elixir
use Config

# disabling SSL
config :hue_sdk, ssl: false

# specifying a custom N-UPnP host
config :hue_sdk, portal_host: "mycustomproxy.com"
```

## Usage

Automatically discover your Hue Bridge device available on your local network:

```elixir
{:nupnp, [bridge]} = HueSDK.Discovery.discover(HueSDK.Discovery.NUPNP)
```

Press the link button on your Hue Bridge device and start the authentication process:

```elixir
bridge = HueSDK.Bridge.authenticate(bridge, "connorlay#huesdk")
```

Make requests to the Hue Bridge REST API:

```elixir
HueSDK.API.Lights.get_all_lights(bridge)

{:ok,
 %{
   "1" => %{
     "capabilities" => %{
       "certified" => true,
       "control" => %{
         "colorgamut" => [[0.6915, 0.3083], [0.17, 0.7], [0.1532, 0.0475]],
         "colorgamuttype" => "C",
         "ct" => %{"max" => 500, "min" => 153},
         "maxlumen" => 800,
         "mindimlevel" => 200
       },
       "streaming" => %{"proxy" => true, "renderer" => true}
     },
     "config" => %{
       "archetype" => "classicbulb",
       "direction" => "omnidirectional",
       "function" => "mixed",
       "startup" => %{"configured" => true, "mode" => "safety"}
     },
     "manufacturername" => "Signify Netherlands B.V.",
     "modelid" => "LCA003",
     "name" => "Floor Lamp",
     "productid" => "Philips-LCA003-1-A19ECLv6",
     "productname" => "Hue color Lamp",
     "state" => %{
       "alert" => "select",
       "bri" => 145,
       "colormode" => "xy",
       "ct" => 443,
       "effect" => "none",
       "hue" => 7675,
       "mode" => "homeautomation",
       "on" => false,
       "reachable" => true,
       "sat" => 199,
       "xy" => [0.5016, 0.4151]
     },
     "swconfigid" => "598716A0",
     "swupdate" => %{
       "lastinstall" => "2021-01-27T22:48:41",
       "state" => "noupdates"
     },
     "swversion" => "1.76.6",
     "type" => "Extended color light",
     "uniqueid" => "00:17:88:01:09:4c:a7:29-0b"
   },
   # ...
  }
}
```

That's it!

<!-- MDOC !-->
