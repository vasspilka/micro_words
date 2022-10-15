defmodule MicroWords.Commands do
  use TypedStruct

  alias MicroWords.Explorers.Action

  typedstruct module: CreateWorld do
    field :name, binary()
    field :ruleset, module()
  end

  typedstruct module: EnterWorld do
    @moduledoc """
    Create user command, also serves as waking up
    and getting the user info.
    """

    field :id, binary()
    field :ruleset, module()
    field :world, binary()
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

  typedstruct module: AffectLocation do
    field :location_id, binary()
    field :action, Action.t(), enforce: true
  end

  typedstruct module: AffectMaterial do
    field :material_id, binary()
    field :action, Action.t(), enforce: true
  end
end
