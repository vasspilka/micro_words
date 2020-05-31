defmodule MicroWords.Worlds.Commands do
  defmodule CreateWorld do
    defstruct [:name, :ruleset]
  end

  defmodule Touch do
    defstruct [:name]
  end
end
