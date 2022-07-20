defmodule MicroWords.Ruleset.Definitions.MaterialDefinition do
  @moduledoc """
  The material definition serves as an abstruction to create different material types.
  """

  alias MicroWords.Worlds.Material
  alias MicroWords.Explorers.Action
  alias MicroWords.Ruleset.Definitions.MaterialDefinition
  alias MicroWords.Ruleset.Definitions.MaterialDefinition.MaterialState

  @callback apply(Material.t(), Action.t()) :: Material.t()

  use TypedStruct

  typedstruct module: MaterialState do
    # field(:level, integer(), default: 0)
    field(:energy, integer(), default: 0)
  end

  typedstruct do
    field(:name, atom())
    field(:data, map())
    field(:state, MaterialState.t())
    field(:description, binary(), default: "")
  end

  defmacro __using__(_material_definition) do
    quote do
      @behaviour MaterialDefinition
    end
  end
end
