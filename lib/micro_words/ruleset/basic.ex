defmodule MicroWords.Rulesets.Basic do
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
    BasicArtefact.PlantArtefact,
    BasicArtefact.SupportArtefact,
    BasicArtefact.WeakenArtefact
    # Protect Artefact:
    # Disenchant Artefact:
    # ? Leach Artefact: (artefact -> explorer)
  ]

  use MicroWords.Ruleset,
    dimensions: [100, 100],
    action_modules: @action_modules

  @impl true
  def initial_energy(), do: 200_000

  @impl true
  def starting_location(), do: [1, 1]
end
