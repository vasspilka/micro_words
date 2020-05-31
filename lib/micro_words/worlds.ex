defmodule MicroWords.Worlds do
  alias MicroWords.Worlds.Commands.{
    CreateWorld
  }

  alias MicroWords.Worlds.Commands.Touch, as: TouchWorld

  alias MicroWords.Worlds.World
  alias MicroWords.Rulesets.Default
  alias MicroWords.Worlds.Artefacts.Commands.Spawn

  def get(name \\ "default") do
    %TouchWorld{name: name}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  def create_world(name \\ "default", ruleset \\ Default) do
    %CreateWorld{name: name}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end
end
