defmodule MicroWords.Events do
  use TypedStruct

  typedstruct module: WorldCreated do
    @derive Jason.Encoder
    @moduledoc """
    A new world was created.
    """

    field :name, binary()
    field :energy, integer()
    field :ruleset, module()
  end

  typedstruct module: ExplorerEnteredWorld do
    @derive Jason.Encoder
    @moduledoc """
    Explorer with `id` entered world at location.
    """

    field :id, binary()
    field :world, binary()
    field :location, MicroWords.dimensions()
  end

  typedstruct module: ExplorerReceivedRuleset do
    @derive Jason.Encoder
    @moduledoc """
    Explorer received a ruleset.

    A ruleset determines the available actions how they affect
    the user and how the world and other entities react.
    """

    field :id, binary()
    field :ruleset, module()
  end

  typedstruct module: ExplorerMoved do
    @derive Jason.Encoder
    @moduledoc """
    Explorer moved around in the world to a new location.
    """

    field :id, binary()
    field :world, binary()
    field :location, MicroWords.dimensions()
  end

  typedstruct module: ExplorerActionTaken do
    @derive Jason.Encoder
    @moduledoc """
    Explorer has taken an action.

    This event will be handled by the ruleset to
    determine how a user action changes their state
    when no other aggregates are affected.

    The ruleset also determines if a reaction should
    happen given the explorer state and action.
    """

    field :id, binary(), enforce: true
    field :action, MicroWords.action(), enforce: true
  end

  typedstruct module: ExplorerAffected do
    @derive Jason.Encoder
    @moduledoc """
    Explorer was affected by action.

    This event will be handled by the ruleset to
    determine how a user gets affected by an action.

    Not all actions create a user affected event.
    """
    field :id, binary(), enforce: true
    field :action, MicroWords.action(), enforce: true
  end

  typedstruct module: LocationAffected do
    @derive Jason.Encoder
    @moduledoc """
    Location was affected by Explorer action.

    This event will be handled by the ruleset to
    determine how a location gets affected by an action.
    """

    field :id, binary(), enforce: true
    field :action, MicroWords.action(), enforce: true
  end
end
