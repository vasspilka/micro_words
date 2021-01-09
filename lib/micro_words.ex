defmodule MicroWords do
  @moduledoc """
  This is the core module for the eventsourcing system.
  With this module we dispatch commands.

  In addition it serves to define key types used across the project.
  """

  alias MicroWords.Worlds.Location
  alias MicroWords.Explorers.{Explorer, Journey}

  alias MicroWords.Events.{
    WorldCreated,
    ExplorerEnteredWorld,
    ExplorerMoved,
    ExplorerActionTaken,
    ExplorerAffected,
    LocationAffected
  }

  alias MicroWords.Commands.{
    AffectLocation,
    TakeAction,
    AffectExplorer
  }

  @type action :: MicroWords.Action.t()
  @type dimensions :: [integer()]
  @type d2_direction :: :north | :east | :south | :west
  @type world_agent :: Journey.t()
  @type entity :: Location.t() | Explorer.t()
  @type affect_command :: AffectLocation.t() | AffectExplorer.t()
  @type action_command :: TakeAction.t()
  @type event ::
          WorldCreated.t()
          | ExplorerEnteredWorld.t()
          | ExplorerMoved.t()
          | ExplorerActionTaken.t()
          | ExplorerAffected.t()
          | LocationAffected.t()

  use Commanded.Application, otp_app: :micro_words

  router(MicroWords.Router)
end
