defmodule HueSDK.HTTPTest do
  use ExUnit.Case, async: true

  alias HueSDK.HTTP

  test "verify_and_pin_self_signed_cert_fun/0" do
    # construct a new verify function
    assert {verify_fun, []} = HTTP.verify_and_pin_self_signed_cert_fun()
    assert is_function(verify_fun)

    # first cert returned is pinned
    assert {:valid, "foo"} = verify_fun.("otp_cert", "reason", "foo")

    # subsequent certs will fail
    assert {:fail, {:bad_cert, 'does not match previous cert'}} =
             verify_fun.("invalid_cert", "reason", "bar")

    # only those matching pinned cert succeed
    assert {:valid, "baz"} = verify_fun.("otp_cert", "reason", "baz")
  end
end
