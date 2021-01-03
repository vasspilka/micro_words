use Mix.Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :micro_words, MicroWords,
  event_store: [
    adapter: Commanded.EventStore.Adapters.InMemory,
    event_store: AxlePay.Core.EventStore
  ]

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :micro_words, MicroWordsWeb.Endpoint,
  http: [port: 4002],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn
