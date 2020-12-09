defmodule MicroWords.Worlds.Location do
  use TypedStruct

  alias MicroWords.Artefact
  alias MicroWords.Worlds.Location

  alias MicroWords.Worlds.Commands.{
    GetLocation,
    AffectLocation
  }

  alias MicroWords.Events.{
    LocationAffected
  }

  typedstruct do
    field :artefact, Artefact.t(), default: nil
  end

  def execute(%Location{}, %GetLocation{} = cmd) do
    []
  end

  def execute(%Location{}, %AffectLocation{} = cmd) do
    %LocationAffected{
      id: cmd.id,
      action: cmd.action
    }
  end

  def apply(%Location{} = state, %LocationAffected{} = evt) do
    evt.action.ruleset.reaction(state, evt.action)
  end

  @spec id_from_attrs(%{location: {integer(), integer()}, world: binary()}) :: binary()
  @doc "Get location_id from attributes of an entity."
  def id_from_attrs(%{location: {x, y}, world: world}) do
    "{#{x},#{y}:#{world}}"
  end
end
