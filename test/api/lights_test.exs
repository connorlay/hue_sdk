defmodule HueSDK.API.LightsTest do
  alias HueSDK.API.Lights
  alias HueSDK.JSON

  use HueSDK.APICase, async: true

  describe "get_all_lights/1" do
    test_generic_json_success("GET", "/lights", &Lights.get_all_lights/1)
    test_generic_http_error(&Lights.get_all_lights/1)
  end

  describe "get_new_lights/1" do
    test_generic_json_success("GET", "/lights/new", &Lights.get_new_lights/1)
    test_generic_http_error(&Lights.get_new_lights/1)
  end

  describe "search_for_new_lights/1" do
    test_generic_json_success("POST", "/lights", &Lights.search_for_new_lights/1)
    test_generic_http_error(&Lights.search_for_new_lights/1)
  end

  describe "get_light_attributes_and_state/2" do
    test_generic_json_success(
      "GET",
      "/lights/1",
      &Lights.get_light_attributes_and_state(&1, "1")
    )

    test_generic_http_error(&Lights.get_light_attributes_and_state(&1, "1"))
  end

  describe "set_light_name/3" do
    test_generic_json_success(
      "PUT",
      "/lights/1",
      %{name: "example"},
      &Lights.set_light_name(&1, "1", "example")
    )
  end
end
