defmodule MicroWords.Worlds.Explorers.Commands do
  use TypedStruct

  alias MicroWords.Rulesets.Action

  # Create user command, also serves as waking up
  # and getting the user info.
  defmodule EnterWorld do
    typedstruct do
      field :id, binary()
      field :world, binary()
    end
  end

  # Accept ruleset from world (happens after create)
  defmodule ReceiveRuleset do
    typedstruct do
      field :id, binary()
      field :ruleset, module()
    end
  end

  # Move around the world
  defmodule Move do
    typedstruct do
      field :id, binary()
      field :direction, MicroWords.direction()
    end
  end

  # Take an action on your current location.
  defmodule TakeAction do
    typedstruct do
      field :id, binary()
      field :action, Action.t()
    end
  end

  # A user is affected by an action
  defmodule Affect do
    # TODO:
    defstruct [:id]
  end
end
