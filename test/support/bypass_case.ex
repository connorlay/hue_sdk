defmodule HueSDK.BypassCase do
  @moduledoc false
  # `ExUnit.CaseTemplate` for testing functions that need a Bypass server running

  alias HueSDK.HTTPHelper

  use ExUnit.CaseTemplate

  using do
    quote do
      import HueSDK.BypassCase
      import HueSDK.HTTPHelper
    end
  end

  setup do
    # start a local bypass server
    bypass = Bypass.open()

    # build a bridge that points to the bypass server
    bridge = HTTPHelper.build_bridge(bypass)

    # ensure the bypass server stops when the test exits
    on_exit(fn -> Bypass.down(bypass) end)
    [bypass: bypass, bridge: bridge]
  end
end
