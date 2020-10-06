defmodule MicroWords.Ruleset do
  @type t :: %{
          grid_size: {integer(), integer()}
        }

  @derive Jason.Encoder
  defstruct [
    :grid_size
  ]
end
