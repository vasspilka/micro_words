defmodule MicroWords.Rulesets.New do
  alias MicroWords.Worlds.{Location, World}
  alias MicroWords.Explorers.{Explorer, Journey}
  alias MicroWords.{Action, Artefact}

  alias MicroWords.Ruleset.Actions.BasicArtefact
  alias MicroWords.Ruleset.Actions.WasdMovement

  @action_modules [
    WasdMovement.MoveSouth,
    WasdMovement.MoveEast,
    WasdMovement.MoveNorth,
    WasdMovement.MoveWest,
    BasicArtefact.ForgeNote,
    BasicArtefact.PlantArtefact
  ]

  use MicroWords.Ruleset,
    dimensions: [1000, 1000],
    action_modules: @action_modules

  @impl true
  def initial_energy(), do: 2_000

  @impl true
  def starting_location(), do: [Enum.random(1..1000), Enum.random(1..1000)]
end
