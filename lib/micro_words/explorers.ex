defmodule MicroWords.Explorers do
  alias MicroWords.Commands.{
    EnterWorld,
    TakeAction
  }

  alias MicroWords.Explorers.Explorer
  alias MicroWords.Explorers.Action

  @spec enter_world(binary(), binary()) :: {:ok, Explorer.t()} | {:error, term()}
  def enter_world(explorer_id, world \\ "basic") do
    {:ok, world_state} = MicroWords.Worlds.view(world)
    ruleset = world_state.ruleset

    %EnterWorld{id: world <> ":" <> explorer_id, world: world, ruleset: ruleset}
    |> MicroWords.dispatch(returning: :aggregate_state)
  end

  @spec take_action(binary(), atom()) :: {:ok, Explorer.t(), Action.t()} | {:error, term()}
  @spec take_action(binary(), atom(), map()) ::
          {:ok, Explorer.t(), Action.t() | nil} | {:error, term()}
  def take_action(explorer_id, type, data \\ %{}) do
    case %TakeAction{id: explorer_id, type: type, data: data}
         |> MicroWords.dispatch(returning: :execution_result) do
      {:ok, %{aggregate_state: explorer, events: [%{action: action}]}} ->
        {:ok, explorer, action}

      {:ok, %{aggregate_state: explorer, events: []}} ->
        {:ok, explorer, nil}

      error ->
        error
    end
  end
end
