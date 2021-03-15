defmodule HueSDK.Discovery.ManualIP do
  @moduledoc """
  Manual IP discovery of the Hue Bridge.
  """

  alias HueSDK.{Config, Discovery}

  @behaviour Discovery

  @impl true
  def do_discovery(opts) do
    {:manual_ip, [to_bridge(opts[:ip_address])]}
  end

  defp to_bridge(ip_address) do
    %HueSDK.Bridge{
      host: ip_address,
      scheme: Config.bridge_scheme()
    }
  end
end
