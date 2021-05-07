defmodule MicroWords.Worlds.Location do
  use TypedStruct

  @type coord :: [integer()]

  alias MicroWords.Artefact
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Location

  alias MicroWords.Commands.{
    GetLocation,
    AffectLocation
  }

  alias MicroWords.Events.{
    LocationAffected
  }

  typedstruct module: Ground do
    field :energy, integer(), default: 0
  end

  typedstruct do
    field :artefact, Artefact.t(), default: nil
    field :ground, Ground.t(), default: %Ground{}
  end

  def execute(%Location{}, %GetLocation{}), do: []

  def execute(%Location{} = state, %AffectLocation{} = cmd) do
    with :ok <- cmd.action.ruleset.validate(state, cmd.action) do
      %LocationAffected{
        id: cmd.action.location_id,
        world: get_world_from_locaction_id(cmd.action.location_id),
        action: %{cmd.action | progress: :passed}
      }
    end
  end

  def apply(%Location{} = state, %LocationAffected{} = evt) do
    location = evt.action.ruleset.apply(state, evt)

    MicroWordsWeb.Endpoint.broadcast(
      "location:#{evt.id}",
      "location_affected",
      location
    )

    location
  end

  @spec id_from_attrs(Explorer.t()) :: binary()
  @doc "Get location_id from attributes of an entity."
  def id_from_attrs(%{location: location, world: world}) do
    Enum.join(location, ",") <> ":" <> world
  end

  @spec get_world_from_locaction_id(binary()) :: binary()
  defp get_world_from_locaction_id(location_id) do
    location_id
    |> String.split(":")
    |> List.last()
  end
end
