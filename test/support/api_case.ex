defmodule HueSDK.APICase do
  @moduledoc false

  alias HueSDK.JSON

  use ExUnit.CaseTemplate

  using do
    quote do
      import HueSDK.APICase
    end
  end

  setup do
    bypass = Bypass.open()
    bridge = %HueSDK.Bridge{host: "localhost:#{bypass.port}", username: "username"}
    [bypass: bypass, bridge: bridge]
  end

  def get(bypass, path, resp_json) do
    setup_bypass_expectation(bypass, "GET", path, nil, resp_json)
  end

  def post(bypass, path, req_json, resp_json) do
    setup_bypass_expectation(bypass, "POST", path, req_json, resp_json)
  end

  def put(bypass, path, req_json, resp_json) do
    setup_bypass_expectation(bypass, "PUT", path, req_json, resp_json)
  end

  def delete(bypass, path, resp_json) do
    setup_bypass_expectation(bypass, "DELETE", path, nil, resp_json)
  end

  defp setup_bypass_expectation(bypass, method, path, req_json, resp_json) do
    Bypass.expect(bypass, fn conn ->
      {:ok, body, conn} = Plug.Conn.read_body(conn)
      assert conn.request_path == path
      assert conn.method == method

      if req_json do
        assert JSON.decode!(body) == req_json
      end

      Plug.Conn.resp(conn, 200, JSON.encode!(resp_json))
    end)
  end
end
