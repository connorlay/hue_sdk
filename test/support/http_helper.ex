defmodule HueSDK.HTTPHelper do
  @moduledoc false
  # Helper functions for testing HTTP calls made by the `HueSDK.HTTP` module.

  # Utlizes `Bypass` as a stubbed HTTP server. SSL is not currently supported, so it is
  # disabled for these tests. See [this GitHub issue](https://github.com/PSPDFKit-labs/bypass/issues/63).

  alias Plug.Conn
  alias HueSDK.Bridge

  import ExUnit.Assertions

  def build_bridge(bypass) do
    %Bridge{
      host: "localhost:#{bypass.port}",
      username: "username"
    }
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
      {:ok, body, conn} = Conn.read_body(conn)
      assert conn.request_path == path
      assert conn.method == method

      if req_json do
        assert Jason.decode!(body) == req_json
      end

      Conn.resp(conn, 200, Jason.encode!(resp_json))
    end)
  end
end
