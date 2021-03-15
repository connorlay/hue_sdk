Application.put_env(:hue_sdk, :bridge_ssl, false)
ExUnit.start(capture_log: true)
