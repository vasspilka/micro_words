defmodule MicroWords.Worlds.Location do
  alias MicroWords.Worlds.Location

  alias MicroWords.Worlds.Commands.{}

  alias MicroWords.Events.{
    WorldCreated
  }

  defstruct [
    :id,
    :artefact
  ]

  def execute(%Location{}, %Touch{}), do: []

  def execute(%Location{}, %{} = cmd) do
  end

  def apply(%World{}, %WorldCreated{} = evt) do
    %World{
      name: evt.name,
      # energy: evt.energy,
      ruleset: evt.ruleset
    }
  end

  # def energy_from_ruleset(ruleset) do
  #   100
  # end
  #
  def location_id(location, world) do
    ""
  end
end
