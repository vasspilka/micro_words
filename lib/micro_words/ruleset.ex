defmodule MicroWords.Ruleset do
  @moduledoc """
  TODO
  """

  alias MicroWords.Action
  alias MicroWords.Worlds.{Location, World}
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
    EnterWorld,
    TakeAction,
    AffectExplorer
  }

  defmodule Behaviour do
    @type entity :: World.t() | Location.t() | Explorer.t() | Journey.t()
    @type command :: AffectLocation.t() | TakeAction.t() | AffectExplorer.t()
    @type event ::
            WorldCreated.t()
            | ExplorerEnteredWorld.t()
            | ExplorerMoved.t()
            | ExplorerActionTaken.t()
            | ExplorerAffected.t()
            | LocationAffected.t()

    # Defined by params
    @callback dimensions() :: [integer()]

    # Defined in ruleset module without fallback
    @callback initial_energy(Explorer.t()) :: integer()
    @callback build_action(Explorer.t(), atom(), map()) :: Action.t()
    @callback valid_action?(Explorer.t(), Action.t()) :: boolean()
    @callback execute(entity(), command()) :: event | [event] | {:error, term()}

    # Defined in ruleset module with fallback that does not change state
    @callback apply(entity(), event()) :: entity()
    @callback reaction(entity(), event()) :: command | [command]
  end

  defmacro __using__(dimensions: dimensions, action_names: _action_names) do
    quote do
      alias MicroWords.{Action, Artefact}
      alias MicroWords.Worlds.{Location, World}
      alias MicroWords.Explorers.{Explorer, Journey}

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

      @behaviour MicroWords.Ruleset.Behaviour
      @before_compile MicroWords.Ruleset

      @impl MicroWords.Ruleset.Behaviour
      def dimensions() do
        unquote(dimensions)
      end

      # defoverridable some: 1
    end
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
