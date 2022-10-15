defmodule MicroWords.Ruleset.Definitions.MaterialDefinition do
  @moduledoc """
  The material definition serves as an abstruction to create different material types.
  """

  use TypedStruct

  alias MicroWords.Worlds.Material
  alias MicroWords.Explorers.Action
  alias MicroWords.Ruleset.Definitions.MaterialDefinition
  alias MicroWords.WorldReaction

  @callback apply(Material.t(), Action.t()) :: Material.t()
  @callback evolve(Material.t()) :: Material.t()

  typedstruct do
    field(:name, atom())
    field(:data_form, MicroWords.data_form(), default: %{})
    field(:world_reactions, [WorldReaction.t()], default: [])
    field(:description, binary(), default: "")
  end

  defmacro __using__(_material_definition) do
    quote do
      @behaviour MaterialDefinition
    end
  end
end
