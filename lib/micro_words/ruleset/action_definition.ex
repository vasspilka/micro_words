defmodule MicroWords.Ruleset.ActionDefinition do
  use TypedStruct

  alias MicroWords.Action
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Location

  alias MicroWords.Events.ExplorerActionTaken

  # alias MicroWords.Commands.{
  #   TakeAction,
  #   AffectExplorer,
  #   AffectLocation
  # }

  typedstruct module: Reward do
    field :xp, integer(), default: 0
    field :energy, integer(), default: 0
  end

  typedstruct module: WorldReaction do
    field :from, MicroWords.action_taken_module()
    field :agent, MicroWords.world_agent_module()
    field :affects, MicroWords.affect_command_module()
  end

  @type data_form :: %{atom() => atom()}
  @type action_data :: map()

  typedstruct do
    field :name, atom()
    field :base_cost, integer(), default: 0
    field :reward, Reward.t(), default: %Reward{}
    field :data_form, data_form(), default: %{}
    field :world_reactions, [WorldReaction.t()], default: []
  end

  # Optional definitions on action modules
  @callback on_build(Explorer.t(), map()) :: Keyword.t()
  @callback on_action_taken(Explorer.t(), Action.t()) :: Keyword.t()
  @callback on_validate(MicroWords.entity(), Action.t()) :: :ok | {:error, atom()}
  @callback affects(MicroWords.entity(), Action.t()) :: Keyword.t()

  # Defined in __using__
  @callback validate(MicroWords.entity(), Action.t()) :: :ok | {:error, atom()}
  @callback build_action(Explorer.t(), map()) :: Action.t()
  @callback reaction(MicroWords.world_agent(), MicroWords.action_taken_event()) ::
              MicroWords.affect_command() | [] | nil
  @callback apply(MicroWords.entity(), MicroWords.affect_event()) :: MicroWords.entity()

  @optional_callbacks reaction: 2, on_action_taken: 2

  defmacro __using__(action_definition) do
    quote do
      @behaviour MicroWords.Ruleset.ActionDefinition
      @before_compile MicroWords.Ruleset.ActionDefinition

      @definition unquote(action_definition)
      @action_name @definition.name
      def definition, do: @definition

      for %WorldReaction{
            from: from,
            agent: agent,
            affects: affects
          } <- @definition.world_reactions do
        @affects_module affects
        def reaction(%agent{}, %from{action: act}) do
          %@affects_module{action: act}
          |> Map.replace(:location_id, act.location_id)
        end
      end

      def validate(%Explorer{} = e, %Action{progress: :drafted} = act) do
        if e.energy > act.cost do
          on_validate(e, act)
        else
          {:error, :insufficient_energy}
        end
      end

      def validate(o, act) do
        on_validate(o, act)
      end

      def apply(entity, %ExplorerActionTaken{action: %Action{type: @action_name} = act}) do
        entity
        |> on_action_taken(act)
        |> Enum.reduce(entity, fn {k, v}, acc ->
          Map.replace(acc, k, v)
        end)
        |> Map.update!(:energy, &(&1 - act.cost))
      end

      def apply(entity, %{action: %Action{type: @action_name} = act}) do
        entity
        |> affects(act)
        |> Enum.reduce(entity, fn {k, v}, acc ->
          Map.replace(acc, k, v)
        end)
      end

      def build_action(explorer, data) do
        explorer
        |> on_build(data)
        |> Enum.reduce(
          %Action{
            type: @definition.name,
            explorer_id: explorer.id,
            location_id: Location.id_from_attrs(explorer),
            data: data,
            ruleset: explorer.ruleset,
            cost: @definition.base_cost
          },
          fn {k, v}, acc ->
            Map.replace(acc, k, v)
          end
        )
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def on_action_taken(_, _), do: []
      def on_build(_, _), do: []
      def affects(_, _), do: []
      def reaction(_, _), do: []
      def on_validate(_, _), do: :ok
    end
  end
end
