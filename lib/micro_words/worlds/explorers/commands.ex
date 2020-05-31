defmodule MicroWords.Worlds.Explorers.Commands do
  defmodule EnterWorld do
    defstruct [:id, :world]
  end

  defmodule ReceiveRuleset do
    defstruct [:id, :ruleset]
  end

  defmodule Move do
    defstruct [:id, :direction]
  end

  defmodule TakeAction do
    defstruct [:id, :action]
  end

end
