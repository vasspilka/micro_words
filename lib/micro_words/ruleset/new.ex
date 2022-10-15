# defmodule MicroWords.Rulesets.New do
#   alias MicroWords.Ruleset.Actions.{
#     MaterialOne,
#     WasdMovement
#   }

#   @action_modules [
#     One.Actions.Movement.MoveSouth,
#     One.Actions.Movement.MoveEast,
#     One.Actions.Movement.MoveNorth,
#     One.Actions.Movement.MoveWest,
#     One.Actions.Material.ForgeNote,
#     One.Actions.Material.PlantMaterial,
#     One.Actions.Material.SupportMaterial,
#     One.Actions.Material.WeakenMaterial
#   ]

#   use MicroWords.Ruleset, %{
#     dimensions: [1000, 1000],
#     action_modules: @action_modules,
#     link_modules: [],
#     material_modules: []
#   }

#   @impl true
#   def initial_energy(), do: 2_000

#   @impl true
#   def starting_location(), do: [Enum.random(1..1000), Enum.random(1..1000)]
# end
