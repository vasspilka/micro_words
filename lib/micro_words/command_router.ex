defmodule MicroWords.CommandRouter do
  use Commanded.Commands.Router

  alias MicroWords.Commands

  dispatch(
    [
      Commands.CreateWorld
    ],
    to: MicroWords.Worlds.World,
    identity: :name,
    identity_prefix: "micro_word_world-"
  )

  dispatch(
    [
      Commands.EnterWorld,
      Commands.TakeAction,
      Commands.AffectExplorer
    ],
    to: MicroWords.Explorers.Explorer,
    identity: :id,
    identity_prefix: "micro_word_explorer-"
  )

  dispatch(
    [
      Commands.AffectLocation
    ],
    to: MicroWords.Worlds.Location,
    identity: :location_id,
    identity_prefix: "micro_word_world_location-"
  )
end
