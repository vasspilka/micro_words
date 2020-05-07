# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :micro_words,
  ecto_repos: [MicroWords.Repo]

# Configures the endpoint
config :micro_words, MicroWordsWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "UzcAq3wD4JPId42NPCuRWlnJqqUB1EWuu8oMf9QOf887cqG0maa1Aa9UZA5lvaFa",
  render_errors: [view: MicroWordsWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: MicroWords.PubSub,
  live_view: [signing_salt: "33vX93sb"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
