defmodule MicroWords.Worlds.Explorers do
  alias MicroWords.Worlds.Explorers.Commands.{
    Touch,
    TakeAction,
    Move
  }

  @type types :: String.t()

  alias MicroWords.Rulesets.Action
  alias MicroWords.Worlds.Explorers.Commands.EnterWorld

  def get(uuid) do
    %Touch{id: uuid}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  def move(explorer, direction) do
    %Move{id: UUID.uuid4(), direction: direction}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @spec enter_world(types) :: term()
  def enter_world(world \\ "default") do
    %EnterWorld{id: UUID.uuid4(), world: world}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  def take_action(explorer, %Action{} = action) do
    %TakeAction{id: explorer.id, action: action}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end
end
