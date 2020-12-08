defmodule MicroWords.Events do
  use TypedStruct

  @derive Jason.Encoder
  typedstruct module: WorldCreated do
    field :name, binary()
    field :energy, integer()
    field :ruleset, module()
  end

  @derive Jason.Encoder
  typedstruct module: ExplorerEnteredWorld do
    field :id, binary()
    field :world, binary()
    field :location, {integer(), integer()}
  end

  @derive Jason.Encoder
  typedstruct module: ExplorerReceivedRuleset do
    field :id, binary()
    field :ruleset, module()
  end

  @derive Jason.Encoder
  typedstruct module: ExplorerMoved do
    field :id, binary()
    field :world, binary()
    field :location, {integer(), integer()}
  end

  @derive Jason.Encoder
  typedstruct module: ExplorerMoved do
    field :id, binary()
    field :world, binary()
    field :location, {integer(), integer()}
  end

  @derive Jason.Encoder
  typedstruct module: ExplorerActionTaken do
    field :id, binary()
    field :action, MicroWords.Rulesets.Action
  end

  @derive Jason.Encoder
  typedstruct module: ExplorerAffected do
    field :id, binary()
    field :action, MicroWords.Rulesets.Action
  end

  @derive Jason.Encoder
  typedstruct module: LocationAffected do
    field :id, binary()
    field :action, MicroWords.Rulesets.Action
  end
end
