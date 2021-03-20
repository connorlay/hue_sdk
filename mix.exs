defmodule HueSDK.MixProject do
  use Mix.Project

  def project do
    [
      app: :hue_sdk,
      version: "0.1.0",
      elixir: "~> 1.11",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "HueSDK",
      source_url: "https://github.com/connorlay/hue_sdk",
      homepage_url: "https://github.com/connorlay/hue_sdk",
      docs: [
        main: "HueSDK",
        # api_reference: false,
        groups_for_modules: [
          "Bridge Discovery": [~r/HueSDK.Discovery.*/],
          "REST API": [~r/HueSDK.API.*/]
        ],
        nest_modules_by_prefix: [HueSDK.API, HueSDK.Discovery],
        extras: ["README.md", "LICENSE", "CHANGELOG.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {HueSDK.Application, []}
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:finch, "~> 0.6.1"},
      {:jason, "~> 1.2"},
      {:mdns, "~> 1.0"},
      {:nimble_options, "~> 0.3.5"},
      {:ex_doc, "~> 0.23", only: :dev, runtime: false},
      {:credo, "~> 1.5", only: [:dev, :test], runtime: false},
      {:dialyxir, "~> 1.0", only: :dev, runtime: false},
      {:bypass, "~> 2.1", only: :test},
      {:mox, "~> 1.0", only: :test}
    ]
  end
end
