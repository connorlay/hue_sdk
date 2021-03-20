defmodule HueSDK.Discovery.ManualIP do
  @moduledoc """
  Manual IP discovery of the Hue Bridge.

  See `HueSDK.Discovery` for available options.
  """

  alias HueSDK.{Bridge, Discovery}

  @behaviour Discovery

  @impl true
  def do_discovery(opts) do
    {:manual_ip, [to_bridge(opts[:ip_address])]}
  end

  defp to_bridge(ip_address) do
    %Bridge{host: ip_address}
  end
end
