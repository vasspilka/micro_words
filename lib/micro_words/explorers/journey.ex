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
    field :location, {integer(), integer()}
  end

  alias MicroWords.Events.{
    ExplorerActionTaken,
    ExplorerEnteredWorld,
    ExplorerReceivedRuleset,
    ExplorerAffected
  }

  alias MicroWords.Explorers.Journey

  alias MicroWords.Explorers.Commands.{
    ReceiveRuleset
  }

  def interested?(%ExplorerEnteredWorld{id: id}), do: {:start!, id}

  def interested?(%ExplorerReceivedRuleset{id: id}), do: {:start!, id}

  def interested?(%ExplorerActionTaken{id: id}), do: {:continue!, id}

  def interested?(%ExplorerAffected{id: id}), do: {:continue!, id}

  def handle(%Journey{}, %ExplorerEnteredWorld{} = evt) do
    %ReceiveRuleset{id: evt.id, ruleset: MicroWords.Rulesets.Default}
  end

  def handle(%Journey{} = state, %ExplorerActionTaken{action: action}) do
    state.ruleset.reaction(state, action)
  end

  def apply(%Journey{} = state, %ExplorerReceivedRuleset{ruleset: ruleset}) do
    %Journey{state | ruleset: ruleset}
  end

  def apply(%Journey{}, %ExplorerEnteredWorld{id: id}) do
    %Journey{explorer_id: id}
  end

  def apply(%Journey{} = state, %ExplorerActionTaken{}) do
    state
  end
end
