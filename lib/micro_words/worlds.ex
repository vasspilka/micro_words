defmodule MicroWords.Worlds do
  alias MicroWords.Commands.{CreateWorld}

  alias MicroWords.Worlds.{Location, World}

  @doc """
  Creates a new world with name from a ruleset.

  A world is generally represented by a two dimentional array
  on which spaces materials can exists and explorers can travel through.
  """
  @spec create(binary(), module()) :: {:ok, %World{}} | {:error, term()}
  def create(name, ruleset) do
    %CreateWorld{name: name, ruleset: ruleset}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @doc """
  Used to get world state.
  """
  @spec view(binary()) :: {:ok, %World{}} | {:error, term()}
  def view(name) do
    case MicroWords.aggregate_state(World, "micro_word_world-" <> name) do
      %{name: nil} -> {:error, :not_found}
      world -> {:ok, world}
    end
  end

  @spec get_location(binary()) :: {:ok, %Location{}} | {:error, term()}
  def get_location(location_id) do
    id = "micro_word_world_location-" <> location_id

    {:ok, MicroWords.aggregate_state(Location, id)}
  end
end
