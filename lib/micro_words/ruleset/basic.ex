defmodule MicroWords.Rulesets.Basic do
  alias MicroWords.Ruleset.Actions.{
    BasicMaterial,
    WasdMovement
  }

  @action_modules [
    WasdMovement.MoveSouth,
    WasdMovement.MoveEast,
    WasdMovement.MoveNorth,
    WasdMovement.MoveWest,
    BasicMaterial.ForgeNote,
    BasicMaterial.PlantMaterial,
    BasicMaterial.SupportMaterial,
    BasicMaterial.WeakenMaterial
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
