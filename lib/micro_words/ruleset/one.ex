defmodule MicroWords.Rulesets.One do
  alias MicroWords.Ruleset.Actions.{
    MaterialOne,
    WasdMovement
  }

  @action_modules [
    WasdMovement.MoveSouth,
    WasdMovement.MoveEast,
    WasdMovement.MoveNorth,
    WasdMovement.MoveWest,
    MaterialOne.ForgeNote,
    MaterialOne.PlantMaterial,
    MaterialOne.SupportMaterial,
    MaterialOne.WeakenMaterial
    # Protect Material:
    # Disenchant Material:
    # ? Leach Material: (material -> explorer)
  ]

  use MicroWords.Ruleset,
    dimensions: [100, 100],
    action_modules: @action_modules

  @impl true
  def initial_energy(), do: 200_000

  @impl true
  def starting_location(), do: [1, 1]
end
