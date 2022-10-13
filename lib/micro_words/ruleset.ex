defmodule MicroWords.Ruleset do
  @moduledoc """
  Ruleset modules define actions and a worlds
  functionality as a whole.
  """

  alias MicroWords.{
    Action
    # UserContext
  }

  alias MicroWords.Explorers.Explorer
  alias MicroWords.Ruleset.Definitions.ActionDefinition

  @type t() :: module()
  @type entity :: MicroWords.entity()
  @type action :: MicroWords.action()
  @type world_agent :: MicroWords.world_agent()
  @type affect_command :: MicroWords.affect_command()
  @type action_command :: MicroWords.action_command()
  @type event :: MicroWords.event()

  @type command :: affect_command() | action_command()

  # Defined by params
  @callback dimensions() :: [integer()]
  ## TODO: figure out input so you can surface this in UI
  ## allowing only executable actions
  @callback action_definitions(term()) :: [ActionDefinition.t()]

  # Defined in ruleset module without fallback
  @callback starting_location() :: [integer()]
  @callback initial_energy() :: integer()

  # TODO
  @callback build_link(Explorer.t(), atom(), map()) :: Action.t()
  @callback build_material(Explorer.t(), atom(), map()) :: Action.t()
  ##
  # Delegated to action modules
  @callback build_action(Explorer.t(), atom(), map()) :: Action.t()
  @callback validate(entity(), action()) :: :ok | {:error, atom()}
  @callback apply(entity(), event()) :: entity()
  @callback reaction(world_agent(), event()) :: command | [command]

  defmacro __using__(
             dimensions: dimensions,
             action_modules: action_modules,
             link_modules: link_modules,
             material_modules: material_modules
           ) do
    quote do
      @behaviour MicroWords.Ruleset
      @before_compile MicroWords.Ruleset

      @action_modules unquote(action_modules)
      @actions @action_modules
               |> Enum.map(fn module ->
                 {module.definition().name, module}
               end)
               |> Enum.into(%{})

      @link_modules unquote(link_modules)
      @links @link_modules
             |> Enum.map(fn module ->
               {module.definition().name, module}
             end)
             |> Enum.into(%{})

      @material_modules unquote(material_modules)
      @materials @material_modules
                 |> Enum.map(fn module ->
                   {module.definition().name, module}
                 end)
                 |> Enum.into(%{})

      @impl MicroWords.Ruleset
      def action_definitions(_ctx) do
        Enum.map(@action_modules, & &1.definition())
      end

      @impl MicroWords.Ruleset
      def link_definitions(_ctx) do
        Enum.map(@link_modules, & &1.definition())
      end

      @impl MicroWords.Ruleset
      def material_definitions(_ctx) do
        Enum.map(@material_modules, & &1.definition())
      end

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
      def build_link(explorer, action_name, data) do
        @links[action_name].build_link(explorer, data)
      end

      @impl MicroWords.Ruleset
      def build_material(explorer, material_name, data) do
        @materials[material_name].build_material(explorer, data)
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
