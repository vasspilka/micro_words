defmodule MicroWords.Worlds.Time do
  @moduledoc """
  Time world agent exists to create the concept of a time dimension in a world.

  Divine actions can be dispatched to affect locations or explorers.
  """

  use Commanded.ProcessManagers.ProcessManager,
    name: "worlds_time",
    application: MicroWords,
    start_from: :origin

  use TypedStruct

  alias MicroWords.Worlds.Time

  alias MicroWords.Events.{
    ExplorerActionTaken,
    ExplorerAffected,
    ExplorerEnteredWorld,
    LocationAffected,
    WorldCreated
  }

  @derive Jason.Encoder
  typedstruct do
    field :world, binary()
    field :ruleset, binary()
    field :explorers, [binary()]
    field :locations, [binary()]
    field :events_count, binary()
  end

  def interested?(%WorldCreated{name: id}), do: {:start!, id}
  def interested?(%ExplorerEnteredWorld{world: id}), do: {:continue!, id}
  def interested?(%ExplorerActionTaken{world: id}), do: {:continue!, id}
  def interested?(%ExplorerAffected{world: id}), do: {:continue!, id}
  def interested?(%LocationAffected{world: id}), do: {:continue!, id}

  def handle(%__MODULE__{} = _state, _evt) do
    # invoke time
    # this is still in planning, maybe ruleset can determine time frequency
    # an idea is to use event count at fibonacci intervals
  end

  def apply(%Time{}, %WorldCreated{} = evt) do
    %Time{
      world: evt.name,
      ruleset: evt.ruleset,
      events_count: 1
    }
  end

  def apply(%Time{} = state, %ExplorerEnteredWorld{id: id}) do
    if :lists.member(id, state.explorers) do
      state
    else
      %Time{state | explorers: [id | state.explorers]}
    end
    |> increase_events_count()
  end

  def apply(%Time{} = state, %LocationAffected{id: id}) do
    if :lists.member(id, state.locations) do
      state
    else
      %Time{state | locations: [id | state.locations]}
    end
    |> increase_events_count()
  end

  def apply(%Time{} = state, _evt), do: increase_events_count(state)

  defp increase_events_count(state) do
    %Time{
      state
      | events_count: state.events_count + 1
    }
  end
end
