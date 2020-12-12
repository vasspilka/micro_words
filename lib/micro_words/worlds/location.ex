defmodule MicroWords.Worlds.Location do
  use TypedStruct

  @type coord :: [integer()]

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

  def execute(%Location{}, %GetLocation{}) do
    []
  end

  def execute(%Location{} = state, %AffectLocation{} = cmd) do
    cmd.action.ruleset.react(state, cmd)
  end

  def apply(%Location{} = state, %LocationAffected{} = evt) do
    evt.action.ruleset.apply(state, evt)
  end

  @spec id_from_attrs(%{location: coord(), world: binary()}) :: binary()
  @doc "Get location_id from attributes of an entity."
  def id_from_attrs(%{location: [x, y], world: world}) do
    "{#{x},#{y}:#{world}}"
  end
end
