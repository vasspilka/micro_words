defmodule MicroWords.Worlds.Explorers.Commands do
  use TypedStruct

  # Development aid to get aggregate state.
  defmodule Touch do
    typedstruct do
      field :id, String.t()
    end
  end

  # Create user command
  defmodule EnterWorld do
    typedstruct do
      field :id, String.t()
      field :world, String.t()
    end
  end

  # Accept ruleset from world (happens after create)
  defmodule ReceiveRuleset do
    defstruct [:id, :ruleset]
  end

  # Move around the world
  defmodule Move do
    typedstruct do
      field :id, String.t()
      field :direction, MicroWords.direction()
    end
  end

  # Take an action on your current location.
  defmodule TakeAction do
    defstruct [:id, :action]
  end

  defmodule React do
    # TODO:
    defstruct [:id]
  end
end
