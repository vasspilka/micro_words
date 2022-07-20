defmodule MicroWords.Ruleset.Definitions.MaterialState do
  use TypedStruct

  typedstruct do
    # field(:level, integer(), default: 0)
    # field(:gen, integer(), default: 0)
    field(:energy, integer(), default: 0)
  end
end
