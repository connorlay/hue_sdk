# Contributing

Welcome! If you are interested in contributing, please read this document.

## Documentation

Like Elixir itself, this project treats documentation as a first-class citizen. Documentation is generated with [ExDoc](https://hexdocs.pm/ex_doc/readme.html) and hosted on [HexDocs](https://hexdocs.pm/). Guides are written in Markdown and added as extra pages to ExDoc. To learn more, please read [Writing Documentation](https://hexdocs.pm/elixir/writing-documentation.html).

All public functions and modules should be documented with `@moduledoc` and `@doc`. All public functions and structs should have their types specified with `@spec` and `@type`. Typespecs are validated with [Dialyxir](https://hexdocs.pm/dialyxir/readme.html). To learn more, please read the [Typespecs documentation](https://hexdocs.pm/elixir/typespecs.html).

## Linting & Testing

[Credo](https://hexdocs.pm/credo/overview.html) is used as the code linter for this project. All Elixir source code is formatted with the [official code formatter](https://hexdocs.pm/mix/Mix.Tasks.Format.html).

Tests are executed with [ExUnit](https://hexdocs.pm/ex_unit/ExUnit.html). Tests involving an actual HTTP server utilize [Bypass](https://hexdocs.pm/bypass/Bypass.html). Mocks for Elixir Behaviours are created with [Mox](https://hexdocs.pm/mox/Mox.html). Line coverage is generated with Erlang's [cover module](https://erlang.org/doc/man/cover.html).

## Continuous Integration & Publishing

[GitHub Actions](https://docs.github.com/en/actions) are used for continuous integration. Pull requests will only be merged once approved and pass all CI checks.

This projects follows [Semantic Versioning](https://semver.org/). Releases are tagged in GitHub and published to [Hex.pm](https://hex.pm/).
