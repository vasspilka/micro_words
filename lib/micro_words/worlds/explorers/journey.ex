defmodule MicroWords.Worlds.Explorers.Journey do
  use Commanded.ProcessManagers.ProcessManager,
    name: "explorers_journey",
    application: MicroWords,
    start_from: :origin

  @derive Jason.Encoder
  defstruct [
    :world,
    :explorer_id
  ]

  alias MicroWords.Events.{
    ArtefactForged,
    ArtefactReceivedAction,
    # ArtefactUnfolded,
    ExplorerEnteredWorld,
    ExplorerActionTaken
  }

  alias MicroWords.Worlds.Explorers.Journey

  alias MicroWords.Worlds.Explorers.Commands.{
    ReceiveRuleset,
    TakeAction
  }

  def interested?(%ExplorerEnteredWorld{id: id}), do: {:start!, id}

  def interested?(%ExplorerActionTaken{id: id}), do: {:continue!, id}

  def handle(%Journey{}, %ExplorerEnteredWorld{} = evt) do
    %ReceiveRuleset{id: evt.id, ruleset: MicroWords.Rulesets.Default}
  end

  def handle(%Journey{}, %ExplorerActionTaken{action: action}) do
    []
  end

  def apply(%Journey{}, %ExplorerEnteredWorld{id: id}) do
    %Journey{explorer_id: id}
  end

  def apply(%Journey{} = state, %ExplorerActionTaken{}) do
    state
  end
end
