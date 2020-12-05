defmodule MicroWords.Worlds.Router do
  alias MicroWords.Worlds.Commands.{
    CreateWorld
  }

  alias MicroWords.Worlds.Commands.Touch, as: TouchWorld

  alias MicroWords.Worlds.Explorers.Commands.{
    EnterWorld,
    ReceiveRuleset,
    Move,
    TakeAction
  }

  alias MicroWords.Worlds.Explorers.Commands.Touch, as: TouchExplorer

  alias MicroWords.Worlds.Artefacts.Commands.{
    Forge,
    React
  }

  use Commanded.Commands.Router

  dispatch(
    [CreateWorld, TouchWorld],
    to: MicroWords.Worlds.World,
    identity: :name,
    identity_prefix: "micro_word_world-"
  )

  dispatch(
    [EnterWorld, ReceiveRuleset, TakeAction, Move, TouchExplorer],
    to: MicroWords.Worlds.Explorers.Explorer,
    identity: :id,
    identity_prefix: "micro_word_world_explorer-"
  )

  dispatch(
    [Forge, React],
    to: MicroWords.Worlds.Artefacts.Artefact,
    identity: :id,
    identity_prefix: "micro_word_world_artefact-"
  )
end
