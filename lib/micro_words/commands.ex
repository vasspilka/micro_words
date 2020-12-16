defmodule MicroWords.Commands do
  use TypedStruct

  alias MicroWords.Action

  typedstruct module: CreateWorld do
    field :name, binary()
    field :ruleset, module()
  end

  typedstruct module: GetLocation do
    field :location_id, binary()
  end

  typedstruct module: AffectLocation do
    field :location_id, binary()
    field :action, MicroWords.Action.t(), enforce: true
  end

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

  typedstruct module: AffectExplorer do
    @moduledoc "A user is affected by an action."

    field :id, binary()
    field :action, Action.t(), enforce: true
  end
end
