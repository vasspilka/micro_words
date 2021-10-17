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
    ExplorerActionTaken,
    ExplorerAffected,
    LocationAffected
  }

  alias MicroWords.Commands.{
    AffectLocation,
    TakeAction,
    AffectExplorer
  }

  @type action :: MicroWords.Explorers.Action.t()
  @type ruleset :: MicroWords.Ruleset.t()
  @type dimensions :: [integer()]
  @type world_agent :: Journey.t()
  @type world_agent_module :: Journey
  @type entity :: Location.t() | Explorer.t()
  @type affect_command :: AffectLocation.t() | AffectExplorer.t()
  @type affect_command_module :: AffectLocation | AffectExplorer
  @type affect_event :: LocationAffected.t() | ExplorerAffected.t()
  @type action_command :: TakeAction.t()
  @type action_taken_event :: ExplorerActionTaken.t()
  @type action_taken_module :: ExplorerActionTaken
  @type event ::
          WorldCreated.t()
          | ExplorerEnteredWorld.t()
          | ExplorerActionTaken.t()
          | ExplorerAffected.t()
          | LocationAffected.t()

  use Commanded.Application, otp_app: :micro_words

  router(MicroWords.CommandRouter)
end
