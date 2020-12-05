defmodule MicroWords.Actions do
  @moduledoc """
  The actions module provides function to make explorer (user) actions.
  """

  alias MicroWords.Worlds.Explorers.Commands.{
    Move,
    TakeAction
  }

  alias MicroWords.Worlds.Explorers.Explorer

  @spec move(binary(), MicroWords.direction()) :: {:ok, %Explorer{}} | {:error, term()}
  def move(id, direction) do
    MicroWords.dispatch(%Move{id: id, direction: direction}, returning: :aggregate_state)
  end

  @spec act(binary(), atom()) :: {:ok, %Explorer{}} | {:error, term()}
  def act(id, action) do
    MicroWords.dispatch(%TakeAction{id: id, action: action}, returning: :aggregate_state)
  end
end
