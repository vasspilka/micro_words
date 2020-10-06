defmodule MicroWords.Worlds do
  alias MicroWords.Worlds.Commands.{
    CreateWorld
  }

  alias MicroWords.Worlds.Commands.Touch, as: TouchWorld

  alias MicroWords.Worlds.World
  alias MicroWords.Rulesets.Default
  alias MicroWords.Worlds.Artefacts.Commands.Forge

  def get(name \\ "default") do
    %TouchWorld{name: name}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @doc """
  Creates a new world with name from a ruleset.

  A world is generally represented by a two dimentional array
  on which spaces artefacts can exists and explorers can travel through.
  """
  def create(name \\ "default", ruleset \\ Default) do
    %CreateWorld{name: name}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end
end
