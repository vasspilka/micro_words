defmodule MicroWords.Explorers.Explorer do
  use TypedStruct

  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Material

  alias MicroWords.Commands.{
    EnterWorld,
    TakeAction,
    AffectExplorer
  }

  alias MicroWords.Events.{
    ExplorerEnteredWorld,
    ExplorerActionTaken,
    ExplorerAffected
  }

  typedstruct do
    field :id, binary()
    field :name, binary()
    field :world, binary(), enforce: true
    field :ruleset, module()
    field :location, MicroWords.Worlds.Location.coord(), enforce: true
    field :energy, integer()
    field :materials, %{binary() => Material.t()}, default: %{}
    field :xp, integer(), default: 0
    field :stats, map(), default: %{}
  end

  def execute(%Explorer{id: nil}, %EnterWorld{ruleset: ruleset} = cmd) when not is_nil(ruleset) do
    %ExplorerEnteredWorld{
      id: cmd.id,
      world: cmd.world,
      ruleset: ruleset,
      location: ruleset.starting_location()
    }
  end

  def execute(%Explorer{world: world}, %EnterWorld{world: cmd_world})
      when cmd_world in [nil, world] do
    []
  end

  def execute(%Explorer{}, %EnterWorld{}) do
    {:error, :worlds_dont_match}
  end

  def execute(%Explorer{id: nil}, %_cmd{}) do
    {:error, :explorer_not_found}
  end

  def execute(%Explorer{id: id} = state, %TakeAction{id: id} = cmd) do
    action = state.ruleset.build_action(state, cmd.type, cmd.data)

    with :ok <- state.ruleset.validate(state, action) do
      %ExplorerActionTaken{
        id: id,
        world: state.world,
        action: %{action | progress: :taken}
      }
    end
  end

  def execute(%Explorer{id: id} = state, %AffectExplorer{id: id} = cmd) do
    %ExplorerAffected{
      id: id,
      world: state.world,
      action: cmd.action
    }
  end

  def apply(%Explorer{}, %ExplorerEnteredWorld{} = evt) do
    %Explorer{
      id: evt.id,
      world: evt.world,
      energy: evt.ruleset.initial_energy(),
      location: evt.location,
      ruleset: evt.ruleset
    }
  end

  def apply(%Explorer{} = state, %ExplorerActionTaken{} = evt) do
    state.ruleset.apply(state, evt)
  end

  def apply(%Explorer{} = state, %ExplorerAffected{} = evt) do
    explorer = state.ruleset.apply(state, evt)

    MicroWordsWeb.Endpoint.broadcast(
      "explorer:#{evt.id}",
      "explorer_affected",
      explorer
    )

    explorer
  end
end
