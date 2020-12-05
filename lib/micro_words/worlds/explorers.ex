defmodule MicroWords.Worlds.Explorers do
  alias MicroWords.Worlds.Explorers.Commands.{
    Touch,
    TakeAction,
    Move
  }

  alias MicroWords.Worlds.Explorers.Explorer
  alias MicroWords.Rulesets.Action
  alias MicroWords.Worlds.Explorers.Commands.EnterWorld

  def get(uuid) do
    %Touch{id: uuid}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

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

  def take_action(explorer, %Action{} = action) do
    %TakeAction{id: explorer.id, action: action}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end
end
