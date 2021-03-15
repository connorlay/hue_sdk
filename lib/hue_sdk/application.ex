# TODO: need to refactor how Finch pools are created so they are either:
# a) actually runtime configurable (on-demand pools), or
# b) only compile-time configurable, which means config/*.exs only
# right now it is a bit of both, which is confusing!
defmodule HueSDK.Application do
  @moduledoc false

  alias HueSDK.{Config, HTTP}

  use Application

  @impl true
  def start(_type, _args) do
    finch_pools = %{
      # pool for N-UPnP discovery requests
      Config.hue_portal_url() => [],

      # pool for bridge requests
      :default => default_pool_opts()
    }

    children = [
      {Finch, name: HTTP, pools: finch_pools}
    ]

    opts = [strategy: :one_for_one, name: HueSDK.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp default_pool_opts() do
    if Config.bridge_ssl?() do
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
end
