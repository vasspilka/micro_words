defmodule MicroWords.Worlds.Router do
  alias MicroWords.Worlds.Commands.{
    AffectLocation,
    CreateWorld,
    GetWorld,
    GetLocation
  }

  alias MicroWords.Explorers.Commands.{
    EnterWorld,
    ReceiveRuleset,
    Move,
    TakeAction
  }

  use Commanded.Commands.Router

  dispatch(
    [CreateWorld, GetWorld],
    to: MicroWords.Worlds.World,
    identity: :name,
    identity_prefix: "micro_word_world-"
  )

  dispatch(
    [EnterWorld, ReceiveRuleset, TakeAction, Move],
    to: MicroWords.Explorers.Explorer,
    identity: :id,
    identity_prefix: "micro_word_explorer-"
  )

  dispatch(
    [GetLocation, AffectLocation],
    to: MicroWords.Worlds.Location,
    identity: :id,
    identity_prefix: "micro_word_world_location-"
  )
end
