defmodule HueSDK.Discovery do
  @moduledoc """
  Automatic discovery of Hue Bridge devices available on the local network.

  See `HueSDK.Discovery.discover/2` for examples.
  """

  alias HueSDK.API.Configuration
  alias HueSDK.Bridge

  @opts_schema [
    ip_address: [
      doc: "The IP address of the Hue Bridge, required for manual discovery.",
      type: :string
    ],
    mdns_namespace: [
      doc: "The multicast DNS namespace to query.",
      type: :string,
      default: "_hue._tcp.local"
    ],
    max_attempts: [
      doc: "How many discovery attempts are made before giving up.",
      type: :pos_integer,
      default: 10
    ],
    sleep: [
      doc: "How long to wait in miliseconds between each attempt.",
      type: :pos_integer,
      default: 5000
    ]
  ]

  @typedoc """
  A list of discovered Hue Bridge devices, tagged by the discovery strategy.
  """
  @type discovery_result :: {atom(), [Bridge.t()]}

  @doc """
  Attempts to discover all available Hue Bridge devices on the local network.

  See `HueSDK.Discovery.discover/2` for more information.
  """
  @callback do_discovery(keyword()) :: discovery_result()

  @doc """
  Attempts to discover all available Hue Bridge devices on the local network.

  ## Examples

  Discovering a Hue Bridge device via the discovery portal URL:

      HueSDK.Discovery.discover(HueSDK.Discovery.NUPNP)

      {:nupnp, [%HueSDK.Bridge{}]}

  Discovering a Hue Bridge device via multicast DNS:

      HueSDK.Discovery.discover(HueSDK.Discovery.MDNS)

      {:mdns, [%HueSDK.Bridge{}]}

  Discovering a Hue Bridge device via a manually supplied IP address :

      HueSDK.Discovery.discover(HueSDK.Discovery.ManualIP, ip_address: "127.0.0.1")

      {:manual_ip, [%HueSDK.Bridge{}]}

  An empty list is returned if no Hue Bridge devices are found:

      HueSDK.Discovery.discover(HueSDK.Discovery.ManualIP, ip_address: "000.0.0.0")

      {:mdns, []}

  If invalid options are given, a `NimbleOptions.ValidationError` is raised:

      HueSDK.Discovery.discover(HueSDK.Discovery.ManualIP, invalid_opt: :invalid_opt)

      ** (NimbleOptions.ValidationError) unknown options [:invalid_opt], valid options are: [:ip_address, :mdns_namespace, :max_attempts, :sleep]

  ## Options
  #{NimbleOptions.docs(@opts_schema)}
  """
  def discover(strategy, opts \\ []) do
    {strategy, bridges} =
      opts
      |> NimbleOptions.validate!(@opts_schema)
      |> strategy.do_discovery()

    {strategy, Enum.map(bridges, &get_bridge_info/1)}
  end

  defp get_bridge_info(bridge) do
    {:ok, config} = Configuration.get_bridge_config(bridge)

    Map.merge(bridge, %{
      api_version: config["apiversion"],
      datastore_version: config["datastoreversion"],
      model_id: config["modelid"],
      mac: config["mac"],
      name: config["name"],
      sw_version: config["swversion"],
      bridge_id: config["bridgeid"]
    })
  end
end
