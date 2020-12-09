defmodule MicroWords.Explorers.Commands do
  use TypedStruct

  alias MicroWords.Rulesets.Action

  typedstruct module: EnterWorld do
    @moduledoc """
    Create user command, also serves as waking up
    and getting the user info.
    """

    field :id, binary()
    field :world, binary()
  end

  typedstruct module: ReceiveRuleset do
    @moduledoc "Accept ruleset from world (happens after create)"

    field :id, binary()
    field :ruleset, module()
  end

  typedstruct module: Move do
    @moduledoc "Move around the world"

    field :id, binary()
    field :direction, MicroWords.direction()
  end

  typedstruct module: TakeAction do
    @moduledoc "Take an action on your current location."

    field :id, binary()
    field :type, atom()
    field :data, map()
  end

  typedstruct module: Affect do
    @moduledoc "A user is affected by an action."

    field :id, binary()
    field :action, Action.t()
  end
end
