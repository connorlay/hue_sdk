defmodule HueSDK.HTTP do
  @moduledoc """
  HTTP client used for all requests made by the Hue SDK.

  Utilizes `Finch` and for requests and connection pooling.
  """

  require Logger

  @type method :: Finch.Request.method()
  @type url :: Finch.Request.url()
  @type headers :: Finch.Request.headers()
  @type body :: iodata() | nil
  @typedoc """
  Function used to parse the raw HTTP response body.
  See `HueSDK.JSON.decode!/1`
  """
  @type decoder_fun :: (binary() -> term())
  @type response :: {:ok, term()} | {:error, Mint.Types.error()}

  @doc """
  Sends an HTTP request and decodes the response.
  """
  @spec request(method(), url(), headers(), body(), decoder_fun()) :: response
  def request(method, url, headers, body, decoder_fun) do
    method
    |> Finch.build("#{scheme()}://#{url}", headers, body)
    |> Finch.request(__MODULE__)
    |> case do
      {:ok, resp} ->
        Logger.debug("HTTP request method '#{method}' url '#{url}' status '#{resp.status}'")
        {:ok, decoder_fun.(resp.body)}

      {:error, error} ->
        Logger.debug("HTTP request method '#{method}' url '#{url}' error '#{inspect(error)}'")
        {:error, error}
    end
  end

  defp scheme do
    if HueSDK.Config.ssl?() do
      :https
    else
      :http
    end
  end

  @doc """
  Builds a custom SSL verification function, used to pin the self-signed certificate returned by the Hue Bridge.

  From the [Philips Hue documentation](https://developers.meethue.com/developing-hue-apps-via-https/): "For your application it is best practice to pin (with the bridge-id) the certificate on first connection with the bridge (“trust on first use”) and check upon later contacts with the same bridge."
  """
  @spec verify_and_pin_self_signed_cert_fun() :: {fun(), []}
  def verify_and_pin_self_signed_cert_fun() do
    table = :ets.new(:hue_sdk_bridge_certs, [:set, :public])

    verify_fun = fn otp_cert, _reason, state ->
      case :ets.lookup(table, :cert) do
        [] ->
          :ets.insert(table, {:cert, otp_cert})
          {:valid, state}

        [{:cert, ^otp_cert}] ->
          {:valid, state}

        _ ->
          {:fail, {:bad_cert, 'does not match previous cert'}}
      end
    end

    {verify_fun, []}
  end
end
