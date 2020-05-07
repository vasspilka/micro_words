defmodule MicroWords.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      MicroWords.Repo,
      # Start the Telemetry supervisor
      MicroWordsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: MicroWords.PubSub},
      # Start the Endpoint (http/https)
      MicroWordsWeb.Endpoint
      # Start a worker by calling: MicroWords.Worker.start_link(arg)
      # {MicroWords.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MicroWords.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MicroWordsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
