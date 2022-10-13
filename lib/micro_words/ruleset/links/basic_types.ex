defmodule MicroWords.Ruleset.One.Links do
  @moduledoc """
  """

  alias MicroWords.Ruleset.Definitions.LinkDefinition

  defmodule CarriesMaterial do
    use LinkDefinition, %LinkDefinition{
      name: :carries_material
    }
  end

  defmodule SituatedAt do
    use LinkDefinition, %LinkDefinition{
      name: :situated_at
    }
  end
end
