defmodule MicroWords.Ruleset.One do
  alias MicroWords.Ruleset
  alias MicroWords.Ruleset.One

  @action_modules [
    One.Actions.Movement.MoveSouth,
    One.Actions.Movement.MoveEast,
    One.Actions.Movement.MoveNorth,
    One.Actions.Movement.MoveWest,
    One.Actions.Material.ForgeNote,
    One.Actions.Material.PlantMaterial,
    One.Actions.Material.SupportMaterial,
    One.Actions.Material.WeakenMaterial
    # Protect Material:
    # Disenchant Material:
    # ? Leach Material: (material -> explorer)
  ]

  @link_modules [
    One.Links.SituatedAt,
    One.Links.CarriesMaterial
  ]

  @material_modules []

  use Ruleset,
    dimensions: [100, 100],
    action_modules: @action_modules,
    link_modules: @link_modules,
    material_modules: @material_modules

  @impl true
  def initial_energy(), do: 200_000

  @impl true
  def starting_location(), do: [1, 1]
end
