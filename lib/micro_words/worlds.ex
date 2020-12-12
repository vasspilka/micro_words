defmodule MicroWords.Worlds do
  alias MicroWords.Commands.{
    CreateWorld,
    GetLocation
  }

  alias MicroWords.Worlds.{Location, World}
  alias MicroWords.Rulesets.Basic

  @doc """
  Creates a new world with name from a ruleset.

  A world is generally represented by a two dimentional array
  on which spaces artefacts can exists and explorers can travel through.
  """
  @spec create(binary(), module()) :: {:ok, %World{}} | {:error, term()}
  def create(name, ruleset) do
    %CreateWorld{name: name, ruleset: ruleset}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @spec get_location(binary()) :: {:ok, %Location{}} | {:error, term()}
  def get_location(location_id) do
    %GetLocation{location_id: location_id}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end
end
