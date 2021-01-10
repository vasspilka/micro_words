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

  @type t() :: module()
  @type entity :: MicroWords.entity()
  @type action :: MicroWords.action()
  @type world_agent :: MicroWords.world_agent()
  @type affect_command :: MicroWords.affect_command()
  @type action_command :: MicroWords.action_command()
  @type event :: MicroWords.event()

  @type command :: affect_command() | action_command()

  # @type availability_fn :: (entity() -> [action()])
  # @type on_build_fn :: (entity(), ActionDefinition.action_data() -> action())
  # @type on_action_taken_fn :: (Explorer.t(), action() -> Explorer.t())
  # @type world_reaction_fn :: (world_agent(), action() -> affect_command())
  # @type affects_fn :: (entity(), action() -> entity())

  # Defined through params
  @callback dimensions() :: [integer()]
  # @callback get_availabe_actions(Explorer.t()) :: [action()]

  # Defined in ruleset module without fallback
  @callback initial_energy(Explorer.t()) :: integer()

  # Delegeted to action modules
  @callback build_action(Explorer.t(), atom(), map()) :: Action.t()
  @callback validate(entity(), action()) :: :ok | {:error, atom()}
  @callback apply(entity(), event()) :: entity()
  @callback reaction(world_agent(), event()) :: command | [command]

  defmacro __using__(dimensions: dimensions, action_modules: action_modules) do
    quote do
      alias MicroWords.{Action, Artefact}
      alias MicroWords.Worlds.{Location, World}
      alias MicroWords.Explorers.{Explorer, Journey}
      alias MicroWords.Ruleset.ActionDefinition

      alias MicroWords.Events.{
        ExplorerActionTaken,
        ExplorerAffected,
        LocationAffected
      }

      alias MicroWords.Commands.{
        AffectExplorer,
        AffectLocation,
        TakeAction
      }

      @behaviour MicroWords.Ruleset
      @before_compile MicroWords.Ruleset

      @action_modules unquote(action_modules)
      @actions @action_modules
               |> Enum.map(fn module ->
                 {module.definition().name, module}
               end)
               |> Enum.into(%{})

      @impl MicroWords.Ruleset
      def apply(o, evt) do
        @actions[evt.action.type].apply(o, evt)
      end

      @impl MicroWords.Ruleset
      def reaction(o, evt) do
        @actions[evt.action.type].reaction(o, evt)
      end

      @impl MicroWords.Ruleset
      def validate(o, action) do
        @actions[action.type].validate(o, action)
      end

      @impl MicroWords.Ruleset
      def build_action(explorer, action_name, data) do
        @actions[action_name].build_action(explorer, data)
      end

      @impl MicroWords.Ruleset
      def dimensions() do
        unquote(dimensions)
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
    end
  end
end
