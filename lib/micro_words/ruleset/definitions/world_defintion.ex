defmodule MicroWords.Ruleset.Definitions.WorldDefinition do
  use TypedStruct

  typedstruct do
    field :name, binary()
    field :ruleset, module()
    field :dimensions, MicroWords.dimensions()
    field :world_energy, integer()
    field :new_explorer_identifier, (() -> binary())
  end
end
