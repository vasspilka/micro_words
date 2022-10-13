defmodule MicroWords do
  @moduledoc """
  This is the core module for the eventsourcing system.
  With this module we dispatch commands.

  In addition it serves to define key types used across the project.
  """
  use TypedStruct

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

  typedstruct module: WorldReaction do
    field(:from, MicroWords.action_taken_module())
    field(:agent, MicroWords.world_agent_module())
    field(:affects, MicroWords.affect_command_module())
  end

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

  @type entity_type :: :explorer | :location | :material | :world
  @type entity_pointer :: %{id: binary(), type: entity_type()}

  @typedoc "Used to define the inputs of actions and materials"
  @type data_form :: %{atom() => atom()}

  use Commanded.Application, otp_app: :micro_words

  router(MicroWords.CommandRouter)
end
