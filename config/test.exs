import Mix.Config

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

config :micro_words, MicroWords.Repo,
  username: "postgres",
  password: "postgres",
  database: "micro_words_test#{System.get_env("MIX_TEST_PARTITION")}",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :micro_words, MicroWordsWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "xEI6SmP2ssR9VHlJASN0CuRsHJE8Ey09I6PLDiETPyzxzkgaxMdgksePh6Lb9kcu",
  server: false

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime

# Print only warnings and errors during test
config :logger, level: :warn
