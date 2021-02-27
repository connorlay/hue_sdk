defmodule HueSDK.Application do
  @moduledoc false

  alias HueSDK.HTTP
  alias HueSDK.Discovery.NUPNP

  use Application

  @impl true
  def start(_type, _args) do
    finch_pools = %{
      # pool for N-UPnP discovery requests
      NUPNP.url() => [],

      # pool for bridge requests
      :default => finch_pool_opts(ssl_enabled?())
    }

    children = [
      {Finch, name: HTTP, pools: finch_pools}
    ]

    opts = [strategy: :one_for_one, name: HueSDK.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp finch_pool_opts(ssl_enabled?) when ssl_enabled? == true do
    [
      conn_opts: [
        transport_opts: [
          verify_fun: HTTP.verify_and_pin_self_signed_cert_fun()
        ]
      ]
    ]
  end

  defp finch_pool_opts(_) do
    []
  end

  defp ssl_enabled? do
    Application.get_env(:hue_sdk, :ssl, false)
  end
end
