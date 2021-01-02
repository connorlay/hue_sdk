defmodule HueSDK.APICase do
  @moduledoc false

  use ExUnit.CaseTemplate

  using do
    quote do
      import HueSDK.APICase
      require HueSDK.APICase
    end
  end

  setup do
    bypass = Bypass.open()
    bridge = %HueSDK.Bridge{host: "localhost:#{bypass.port}", username: "username"}
    [bypass: bypass, bridge: bridge]
  end

  defmacro api_test(api_fun) do
  end

  defmacro test_generic_json_success(method, path, body \\ nil, api_fun) do
    quote do
      test "returns parsed JSON if the request succeeds", %{bypass: bypass, bridge: bridge} do
        Bypass.expect(bypass, fn conn ->
          if unquote(body) do
            {:ok, body, conn} = Plug.Conn.read_body(conn)
            assert body == HueSDK.JSON.encode!(unquote(body))
          end

          assert conn.request_path == Path.join(["/api/#{bridge.username}", unquote(path)])
          assert conn.method == unquote(method)
          Plug.Conn.resp(conn, 200, HueSDK.JSON.encode!(json_resp()))
        end)

        assert {:ok, json_resp()} == unquote(api_fun).(bridge)
      end
    end
  end

  defmacro test_generic_http_error(api_fun) do
    quote do
      test "returns a http error if the request fails", %{bypass: bypass, bridge: bridge} do
        Bypass.down(bypass)
        assert {:error, http_error()} == unquote(api_fun).(bridge)
      end
    end
  end

  def json_resp(), do: %{"1" => %{"name" => "example"}}
  def http_error(), do: %Mint.TransportError{reason: :econnrefused}
end
