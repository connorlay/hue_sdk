defmodule HueSDK.Application do
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      {Finch, name: HueSDK.API}
    ]

    opts = [strategy: :one_for_one, name: HueSDK.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
