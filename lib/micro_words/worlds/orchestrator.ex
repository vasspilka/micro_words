defmodule MicroWords.Worlds.Orchestrator do
  @moduledoc """
  Creates and manages the world processes.
  """
  use DynamicSupervisor

  def start_world(_name) do
    DynamicSupervisor.start_child(__MODULE__, {Agent, fn -> %{} end})
  end

  @doc false
  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  @doc false
  def init(_init_arg) do
    DynamicSupervisor.init(strategy: :one_for_one)
  end
end
