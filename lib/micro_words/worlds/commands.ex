defmodule MicroWords.Worlds.Commands do
  use TypedStruct

  typedstruct module: CreateWorld do
    field :name, binary()
    field :ruleset, module()
  end

  typedstruct module: GetWorld do
    field :name, binary()
  end

  typedstruct module: GetLocation do
    field :location_id, binary()
  end

  typedstruct module: AffectLocation do
    field :location_id, binary()
  end
end
