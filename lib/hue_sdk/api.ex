defmodule HueSDK.API do
  @moduledoc false

  require Logger

  @doc false
  def request(method, url, decoder_fun) do
    do_request(method, url, [], nil, decoder_fun)
  end

  def request(method, url, body, decoder_fun) when is_binary(body) or is_nil(body) do
    do_request(method, url, [], body, decoder_fun)
  end

  def request(method, url, headers, decoder_fun) when is_list(headers) do
    do_request(method, url, headers, nil, decoder_fun)
  end

  def request(method, url, headers, body, decoder_fun) do
    do_request(method, url, headers, body, decoder_fun)
  end

  defp do_request(method, url, headers, body, decoder_fun) do
    method
    |> Finch.build(url, headers, body)
    |> Finch.request(__MODULE__)
    |> case do
      {:ok, resp} ->
        Logger.debug("HueSDK request #{method} #{resp.status} #{url}")
        decoder_fun.(resp.body)

      error ->
        Logger.warn("HueSDK request #{method} #{url}")
        error
    end
  end
end
