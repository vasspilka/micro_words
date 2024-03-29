# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :micro_words,
  # consider list and using macro for types.
  worlds: %{
    "dev_world" => MicroWords.Rulesets.Basic,
    "dev_world_2" => MicroWords.Rulesets.Basic,
    "new_world" => MicroWords.Rulesets.New
  },
  ecto_repos: [MicroWords.Repo],
  generators: [binary_id: true]

# Configures the endpoint
config :micro_words, MicroWordsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UzcAq3wD4JPId42NPCuRWlnJqqUB1EWuu8oMf9QOf887cqG0maa1Aa9UZA5lvaFa",
  render_errors: [view: MicroWordsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MicroWords.PubSub,
  live_view: [signing_salt: "33vX93sb"]

config :micro_words, MicroWords.EventStore,
  username: "postgres",
  password: "postgres",
  database: "micro_words_eventstore_dev",
  hostname: "localhost",
  # Commanded.Serialization.JsonSerializer
  serializer: EventStore.TermSerializer

config :micro_words, event_stores: [MicroWords.EventStore]

config :micro_words, MicroWords,
  event_store: [
    adapter: Commanded.EventStore.Adapters.EventStore,
    event_store: MicroWords.EventStore
  ],
  pubsub: :local,
  registry: :local,
  snapshotting: %{
    MicroWords.Worlds.Location => [
      snapshot_every: 1,
      snapshot_version: 1
    ],
    MicroWords.Explorers.Explorer => [
      snapshot_every: 1,
      snapshot_version: 1
    ]
  }

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
