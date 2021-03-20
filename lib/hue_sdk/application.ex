defmodule HueSDK.Application do
  @moduledoc false

  alias HueSDK.{Config, HTTP}

  use Application

  @impl true
  def start(_type, _args) do
    finch_pools = %{
      # pool for N-UPnP discovery requests
      nupnp_url() => [],

      # pool for bridge requests
      :default => pool_opts()
    }

    children = [
      {Finch, name: HTTP, pools: finch_pools}
    ]

    opts = [strategy: :one_for_one, name: HueSDK.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp pool_opts() do
    if Config.ssl?() do
      [
        conn_opts: [
          transport_opts: [
            verify_fun: HTTP.verify_and_pin_self_signed_cert_fun()
          ]
        ]
      ]
    else
      []
    end
  end

  defp nupnp_url() do
    scheme =
      if Config.ssl?() do
        "https"
      else
        "http"
      end

    "#{scheme}://#{Config.portal_host()}"
  end
end
