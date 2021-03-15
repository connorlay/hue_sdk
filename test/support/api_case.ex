defmodule HueSDK.APICase do
  @moduledoc """
  `ExUnit.CaseTemplate` used for testing functions under the `HueSDK.API` namespace.

  Utlizes `Bypass` as a stubbed HTTP server. SSL is not currently supported, so it is
  disabled for these tests. See [this GitHub issue](https://github.com/PSPDFKit-labs/bypass/issues/63).
  """

  alias HueSDK.JSON

  use ExUnit.CaseTemplate

  using do
    quote do
      import HueSDK.APICase
    end
  end

  setup do
    bypass = Bypass.open()

    bridge = %HueSDK.Bridge{
      scheme: :http,
      host: "localhost:#{bypass.port}",
      username: "username"
    }

    Application.put_env(:hue_sdk, :portal_url, "http://localhost:#{bypass.port}")

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
