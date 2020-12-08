defmodule MicroWords.Worlds.Explorers.Explorer do
  use TypedStruct

  alias MicroWords.Worlds.Explorers.Explorer
  alias MicroWords.Artefact

  alias MicroWords.Worlds.Explorers.Commands.{
    EnterWorld,
    ReceiveRuleset,
    Move,
    TakeAction
    # Affect
  }

  alias MicroWords.Events.{
    ExplorerEnteredWorld,
    ExplorerReceivedRuleset,
    ExplorerMoved,
    ExplorerActionTaken,
    ExplorerAffected
  }

  typedstruct do
    field :id, binary()
    field :world, binary()
    field :ruleset, module()
    field :location, {integer(), integer()}
    field :energy, integer()
    field :artefacts, %{binary() => Artefact.t()}, default: %{}
    field :xp, integer(), default: 0
    field :stats, map(), default: %{}
  end

  def execute(%Explorer{id: nil}, %EnterWorld{} = cmd) do
    %ExplorerEnteredWorld{
      id: cmd.id,
      world: cmd.world,
      location: {1, 1}
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

  def execute(%Explorer{id: id}, %ReceiveRuleset{id: id} = cmd) do
    %ExplorerReceivedRuleset{
      id: id,
      ruleset: cmd.ruleset
    }
  end

  def execute(
        %Explorer{id: id, location: {current_x, current_y}} = state,
        %Move{
          id: id,
          direction: direction
        }
      ) do
    {max_x, max_y} = state.ruleset.dimensions()

    x =
      case {current_x, direction} do
        {_, direction} when direction in [:north, :south] -> current_x
        {1, :west} -> max_x
        {_, :west} -> current_x - 1
        {^max_x, :east} -> 1
        {_, :east} -> current_x + 1
      end

    y =
      case {current_y, direction} do
        {_, direction} when direction in [:east, :west] -> current_y
        {^max_y, :north} -> 1
        {_, :north} -> current_y + 1
        {1, :south} -> max_y
        {_, :south} -> current_y - 1
      end

    %ExplorerMoved{
      id: id,
      world: state.world,
      location: {x, y}
    }
  end

  def execute(%Explorer{id: id} = state, %TakeAction{id: id} = cmd) do
    action = state.ruleset.build_action(state, cmd.type, cmd.data)

    if state.ruleset.valid_for?(state, action) do
      %ExplorerActionTaken{
        id: id,
        world: state.world,
        action: action
      }
    end
  end

  def apply(%Explorer{}, %ExplorerEnteredWorld{} = evt) do
    %Explorer{id: evt.id, world: evt.world, location: evt.location}
  end

  def apply(%Explorer{} = state, %ExplorerReceivedRuleset{} = evt) do
    %Explorer{state | ruleset: evt.ruleset, energy: evt.ruleset.initial_energy(state)}
  end

  def apply(%Explorer{} = state, %ExplorerMoved{location: location}) do
    %Explorer{state | location: location}
  end

  def apply(%Explorer{} = state, %ExplorerActionTaken{} = evt) do
    state.ruleset.apply(state, evt.action)
  end

  def apply(%Explorer{} = state, %ExplorerAffected{} = evt) do
    # TODO
  end
end
