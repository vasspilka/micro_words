defmodule MicroWords.Worlds.Explorers.Explorer do
  alias MicroWords.Worlds.Explorers.Explorer

  alias MicroWords.Worlds.Explorers.Commands.{
    EnterWorld,
    ReceiveRuleset,
    Touch,
    Move,
    TakeAction,
    React
    # LevelUp
  }

  alias MicroWords.Events.{
    ExplorerEnteredWorld,
    ExplorerReceivedRuleset,
    ExplorerMoved,
    ExplorerActionTaken
  }

  defstruct [
    :id,
    :world,
    :coordinates,
    :energy,
    :ruleset,
    level: 1
  ]

  def execute(%Explorer{id: id}, %Touch{}) when is_binary(id), do: []
  def execute(%Explorer{}, %Touch{}), do: {:error, :not_existing}

  def execute(%Explorer{id: nil}, %EnterWorld{} = cmd) do
    %ExplorerEnteredWorld{
      id: cmd.id,
      world: cmd.world
    }
  end

  def execute(%Explorer{id: nil}, %ReceiveRuleset{} = cmd) do
    {:error, :not_found}
  end

  def execute(%Explorer{id: id}, %ReceiveRuleset{id: id} = cmd) do
    %ExplorerReceivedRuleset{
      id: id,
      ruleset: cmd.ruleset
    }
  end

  def execute(%Explorer{id: id} = state, %Move{id: id} = cmd) do
    %ExplorerMoved{
      id: id,
      world: cmd.world,
      direction: cmd.direction
    }
  end

  def execute(%Explorer{id: id} = state, %TakeAction{id: id} = cmd) do
    if state.ruleset.valid_for?(state, cmd.action) do
      %ExplorerActionTaken{
        id: id,
        world: cmd.world,
        action: cmd.action
      }
    end
  end

  def apply(%Explorer{} = state, %ExplorerEnteredWorld{} = evt) do
    %Explorer{id: evt.id, world: evt.world}
  end

  def apply(%Explorer{} = state, %ExplorerReceivedRuleset{} = evt) do
    %Explorer{state | ruleset: evt.ruleset, energy: evt.ruleset.initial_energy(state)}
  end

  def apply(%Explorer{} = state, %ExplorerMoved{} = evt) do
    new_coordinates =
      case evt.direction do
        any -> {0, 0}
      end

    %Explorer{state | coordinates: new_coordinates}
  end

  def apply(%Explorer{} = state, %ExplorerActionTaken{} = evt) do
    state.ruleset.apply(state, evt.action)
  end
end
