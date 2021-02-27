# Elixir Hue SDK

<!-- MDOC !-->

An unofficial Elixir SDK for the Philips Hue personal wireless lightning system.

## Features

Note: Viewing the official developer documentation requires [registering](https://developers.meethue.com/login/) for a Hue developer account!

### REST API

The Hue SDK supports the following [REST API resources](https://developers.meethue.com/develop/hue-api/):

* [x] [Lights](https://developers.meethue.com/develop/hue-api/lights-api/)
* [x] [Groups](https://developers.meethue.com/develop/hue-api/groupds-api/)
* [x] [Schedules](https://developers.meethue.com/develop/hue-api/3-schedules-api/)
* [x] [Scenes](https://developers.meethue.com/develop/hue-api/4-scenes/)
* [x] [Sensors](https://developers.meethue.com/develop/hue-api/5-sensors-api/)
* [x] [Rules](https://developers.meethue.com/develop/hue-api/6-rules-api/)
* [x] [Configuration](https://developers.meethue.com/develop/hue-api/7-configuration-api/)
* [x] [Resourcelinks](https://developers.meethue.com/develop/hue-api/9-resourcelinks-api/)
* [x] [Capabilities](https://developers.meethue.com/develop/hue-api/10-capabilities-api/)

### Entertainment API

The Hue SDK does not support the [Entertainment API](https://developers.meethue.com/develop/hue-entertainment/), but is on the roadmap for future versions.

* [ ] [Streaming](https://developers.meethue.com/develop/hue-entertainment/philips-hue-entertainment-api/)
* [ ] [Sync Box API](https://developers.meethue.com/develop/hue-entertainment/hue-hdmi-sync-box-api/)

### Bridge Discovery

The Hue SDK supports [automatic bridge discovery](https://developers.meethue.com/develop/application-design-guidance/hue-bridge-discovery/) via the following protocols:

* [x] N-UPnP
* [x] mDNS
* [ ] UPnP
* [ ] IP Scan

## Protocols

* [x] HTTP
* [x] [HTTPS](https://developers.meethue.com/developing-hue-apps-via-https/)

### Remote Calls

* [ ] [Remote API](https://developers.meethue.com/develop/hue-api/remote-api-quick-start-guide/)
* [ ] [Remote Authentication](https://developers.meethue.com/develop/hue-api/remote-authentication/)

<!-- MDOC !-->

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
