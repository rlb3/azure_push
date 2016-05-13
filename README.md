# Azure Push Client

**Azure push client**

Based on ruby Azure Push gem [link](https://github.com/christian-s/azure-push)

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed as:

  1. Add azure_push to your list of dependencies in `mix.exs`:

        def deps do
          [{:azure_push, "~> 0.0.1"}]
        end

  2. Ensure azure_push is started before your application:

        def application do
          [applications: [:azure_push]]
        end

## Todo
    - Tests
    - Tags
    - gcm
