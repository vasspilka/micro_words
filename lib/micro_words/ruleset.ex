defmodule MicroWords.Ruleset do
  @moduledoc """
  Ruleset modules define actions and a worlds
  functionality as a whole.
  """

  alias MicroWords.Action
  alias MicroWords.Worlds.{Location, World}
  alias MicroWords.Explorers.{Explorer, Journey}
  alias MicroWords.Ruleset.ActionDefinition

  alias MicroWords.Events.{
    ExplorerActionTaken,
    ExplorerAffected,
    LocationAffected
  }

  alias MicroWords.Commands.{
    AffectLocation,
    TakeAction,
    AffectExplorer
  }

  @type entity :: MicroWords.entity()
  @type action :: MicroWords.action()
  @type command :: MicroWords.command()
  @type world_agent :: MicroWords.world_agent()
  @type affect_command :: MicroWords.affect_command()
  @type event :: MicroWords.event()

  @type availability_fn :: (entity() -> [action()])
  @type on_build_fn :: (entity(), ActionDefinition.action_data() -> action())
  @type on_action_taken_fn :: (Explorer.t(), action() -> Explorer.t())
  @type world_reaction_fn :: (world_agent(), action() -> affect_command())
  @type affects_fn :: (entity(), action() -> entity())

  # Defined through params
  @callback dimensions() :: [integer()]
  @callback get_availabe_actions(Explorer.t()) :: [action()]

  # Defined in ruleset module without fallback
  @callback initial_energy(Explorer.t()) :: integer()
  @callback build_action(Explorer.t(), atom(), map()) :: Action.t()
  @callback valid_action?(Explorer.t(), Action.t()) :: boolean()
  @callback execute(entity(), command()) :: event | [event] | {:error, term()}

  # Defined in ruleset module with fallback that does not change state
  @callback apply(entity(), event()) :: entity()
  @callback reaction(entity(), event()) :: command | [command]

  defmacro __using__(dimensions: dimensions, action_definitions: _action_names) do
    quote do
      alias MicroWords.{Action, Artefact}
      alias MicroWords.Worlds.{Location, World}
      alias MicroWords.Explorers.{Explorer, Journey}
      alias MicroWords.Ruleset.ActionDefinition

      alias MicroWords.Events.{
        # WorldCreated,
        # ExplorerEnteredWorld,
        # ExplorerMoved,
        ExplorerActionTaken,
        ExplorerAffected,
        LocationAffected
      }

      alias MicroWords.Commands.{
        # EnterWorld,
        AffectExplorer,
        AffectLocation,
        TakeAction
      }

      @behaviour MicroWords.Ruleset
      @before_compile MicroWords.Ruleset

      @impl MicroWords.Ruleset.Behaviour
      def dimensions() do
        unquote(dimensions)
      end

      # defoverridable some: 1
    end

    # defmodule Action do
    #   defmacro defaction(args, reaction: reaction) do
    #     quote do
    #       def reaction(event, metadata) do
    #         unquote(reaction).()
    #       end

    #       # def reaction(unquote(event), unquote(metadata)) do
    #       #   {:error, exception, __STACKTRACE__}
    #       # end

    #       # def apply(unquote(event), unquote(metadata)) do
    #       #   {:error, exception, __STACKTRACE__}
    #       # end
    #     end
    #   end
    # end
  end

  defmacro __before_compile__(_env) do
    quote do
      @impl MicroWords.Ruleset.Behaviour
      def reaction(%Journey{}, %ExplorerActionTaken{}) do
        []
      end

      @impl MicroWords.Ruleset.Behaviour
      def apply(o, _), do: o
    end
  end
end
