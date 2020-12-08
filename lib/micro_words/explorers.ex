defmodule MicroWords.Worlds.Explorers do
  alias MicroWords.Worlds.Explorers.Commands.{
    TakeAction,
    Move
  }

  alias MicroWords.Worlds.Explorers.Explorer
  alias MicroWords.Rulesets.Action
  alias MicroWords.Worlds.Explorers.Commands.EnterWorld

  @spec enter_world(binary(), binary()) :: {:ok, %Explorer{}} | {:error, term()}
  def enter_world(explorer_id, world \\ "default") do
    %EnterWorld{id: explorer_id, world: world}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @spec move(binary(), MicroWords.direction()) :: {:ok, %Explorer{}} | {:error, term()}
  def move(explorer_id, direction) do
    %Move{id: explorer_id, direction: direction}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @spec make_action(binary(), atom(), map()) :: {:ok, %Explorer{}} | {:error, term()}
  def make_action(explorer_id, type, data) do
    %TakeAction{id: explorer_id, type: type, data: data}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end
end
