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
    field :id, binary()
    field :artefact, Artefact.t()
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

  def apply(%Location{}, %LocationAffected{} = evt) do
    %LocationAffected{id: evt}
  end
end
