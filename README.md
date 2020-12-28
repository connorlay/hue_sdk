# Elixir Hue SDK

An unofficial Elixir SDK for the Philips Hue personal wireless lightning system.

## Features

Note: Viewing the official developer documentation requires [registering](https://developers.meethue.com/login/) for a Hue developer account!

### REST API

The Hue SDK supports the following [REST API resources](https://developers.meethue.com/develop/hue-api/). More will be added in the future.

* [x] [Lights](https://developers.meethue.com/develop/hue-api/lights-api/)
* [ ] [Groups](https://developers.meethue.com/develop/hue-api/groupds-api/)
* [ ] [Schedules](https://developers.meethue.com/develop/hue-api/3-schedules-api/)
* [ ] [Scenes](https://developers.meethue.com/develop/hue-api/4-scenes/)
* [ ] [Sensors](https://developers.meethue.com/develop/hue-api/5-sensors-api/)
* [ ] [Rules](https://developers.meethue.com/develop/hue-api/6-rules-api/)
* [x] [Configuration](https://developers.meethue.com/develop/hue-api/7-configuration-api/)
* [ ] [Resourcelinks](https://developers.meethue.com/develop/hue-api/9-resourcelinks-api/)
* [ ] [Capabilities](https://developers.meethue.com/develop/hue-api/10-capabilities-api/)

### Bridge Discovery

The Hue SDK supports [automatic bridge discovery](https://developers.meethue.com/develop/application-design-guidance/hue-bridge-discovery/) via the following protocols. More will be added in the future.

* [ ] UPnP
* [ ] N-UPnP
* [ ] IP Scan
* [x] [mDNS](https://en.wikipedia.org/wiki/Multicast_DNS)

### Entertainment API

The Hue SDK does not support the [Entertainment API](https://developers.meethue.com/develop/hue-entertainment/), but is on the roadmap for future versions.

* [ ] [Streaming](https://developers.meethue.com/develop/hue-entertainment/philips-hue-entertainment-api/)
* [ ] [Sync Box API](https://developers.meethue.com/develop/hue-entertainment/hue-hdmi-sync-box-api/)

## Installation

```elixir
def deps do
  [
    {:hue_sdk, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hue_sdk](https://hexdocs.pm/hue_sdk).
