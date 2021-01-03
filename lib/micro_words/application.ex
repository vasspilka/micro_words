defmodule MicroWords.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start Pubsub
      {Phoenix.PubSub, name: MicroWords.PubSub},
      # Microwords Commanded Application
      MicroWords,
      MicroWordsWeb.Endpoint,
      # Commanded Handlers
      MicroWords.Explorers.Journey
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MicroWords.Supervisor]
    app = Supervisor.start_link(children, opts)

    # Create worlds provided in config
    :micro_words
    |> Application.get_env(:worlds)
    |> Enum.each(fn {world, ruleset} ->
      MicroWords.Worlds.create(world, ruleset)
    end)

    app
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MicroWordsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
