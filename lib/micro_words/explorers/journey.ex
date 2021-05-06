defmodule MicroWords.Explorers.Journey do
  use Commanded.ProcessManagers.ProcessManager,
    name: "explorers_journey",
    application: MicroWords,
    start_from: :origin

  use TypedStruct

  @derive Jason.Encoder
  typedstruct do
    field :explorer_id, binary()
    field :world, binary()
    field :ruleset, module()
  end

  alias MicroWords.Events.{
    ExplorerActionTaken,
    ExplorerEnteredWorld,
    ExplorerAffected,
    LocationAffected
  }

  alias MicroWords.Explorers.Journey

  alias MicroWords.Commands.{
    AffectLocation,
    AffectExplorer
  }

  def interested?(%ExplorerEnteredWorld{id: id}), do: {:start!, id}
  def interested?(%ExplorerActionTaken{id: id}), do: {:continue!, id}
  def interested?(%ExplorerAffected{id: id}), do: {:continue!, id}
  def interested?(%LocationAffected{action: %{explorer_id: id}}), do: {:continue!, id}

  def handle(%Journey{} = state, %ExplorerActionTaken{} = evt) do
    state.ruleset.reaction(state, evt)
  end

  def handle(%Journey{} = state, %LocationAffected{} = evt) do
    %AffectExplorer{id: state.explorer_id, action: evt.action}
  end

  def apply(%Journey{}, %ExplorerEnteredWorld{} = evt) do
    %Journey{explorer_id: evt.id, world: evt.world, ruleset: evt.ruleset}
  end

  def apply(%Journey{} = state, _evt), do: state

  def(error(_error, %AffectLocation{action: act}, ctx)) do
    {:continue, [%AffectExplorer{id: act.explorer_id, action: %{act | progress: :failed}}], ctx}
  end
end
