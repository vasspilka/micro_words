defmodule MicroWords.Ruleset.ActionDefinition do
  @moduledoc """
  Action definition is an abstruction to help defining existing actions for use in rulesets.

  Fields Documentation:

  - name: The action name is used to identify an action. Rulesets must not have more than
  one action with the same name.
  - base_cost: The base energy cost of an action, the end action cost can be more depending on the
  on_build/2 callback.
  - reward: A reward given to Explorer when the action is successfull.
  - data_form: The form of what the input data for this action should look.
  - world_reactions: This is a list of WorldReaction structs that helps define any reactions.
  that can happen and the agents responsible to do them.
  - descripton: A small description of the action that can be read by users.
  - key_binding: The key to bind this action to, used in the UI.
  - type: One of the 4 defined action types.



  Action Types:

  There are four action types available, each one represents what is the intent of this action.

  - :movement
  The movement actions result in the Explorer changing it's location.

  - :simple
  These actions only affect the Explorer and do not require any world reactions.

  - :reactive
  These actions will react with other entities, reactive actions might fail and in that case need
  to be reverted. Reactive action can cause a longer chain of events where for example an
  explorer affects a location that then in turn affects another location that then affects an
  explorer.

  For reactive functions it is important to know the progress if the action as it affect how it will continue to
  be handled.

  - :divine
  These actions are *NOT* taken by the explorer, instead these types of actions can affect any entity
  and are done by the system.
  """
  use TypedStruct

  alias MicroWords.Action
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Location

  alias MicroWords.Events.ExplorerActionTaken

  typedstruct module: Reward do
    field(:xp, integer(), default: 0)
    field(:energy, integer(), default: 0)
  end

  typedstruct module: WorldReaction do
    field(:from, MicroWords.action_taken_module())
    field(:agent, MicroWords.world_agent_module())
    field(:affects, MicroWords.affect_command_module())
  end

  @type data_form :: %{atom() => atom()}
  @type action_data :: map()
  @type action_type :: :movement | :simple | :reactive | :divine

  # TODO: 1 length character
  @type keypress :: binary()

  typedstruct do
    field(:name, atom())
    field(:base_cost, integer(), default: 0)
    field(:reward, Reward.t(), default: %Reward{})
    field(:data_form, data_form(), default: %{})
    field(:world_reactions, [WorldReaction.t()], default: [])
    field(:description, binary(), default: "")
    field(:key_binding, keypress())
    field(:type, action_type())
  end

  # Optional definitions on action mo didules
  @callback on_build(Explorer.t(), map()) :: Keyword.t()
  @callback on_action_taken(Explorer.t(), Action.t()) :: Keyword.t()
  @callback on_validate(MicroWords.entity(), Action.t()) :: :ok | {:error, atom()}
  @callback affects(MicroWords.entity(), Action.t()) :: Keyword.t()
  # TODO: Maybe available_when

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
        validated_data = validate_data_form(data)

        explorer
        |> on_build(validated_data)
        |> Enum.reduce(
          %Action{
            type: @definition.name,
            explorer_id: explorer.id,
            location_id: Location.id_from_attrs(explorer),
            input_data: validated_data,
            ruleset: explorer.ruleset,
            cost: @definition.base_cost
          },
          fn {k, v}, action ->
            Map.replace(action, k, v)
          end
        )
      end

      def validate_data_form(data) do
        @definition.data_form
        |> Enum.map(fn {data_key, data_type} ->
          form_input = data[data_key] || data["#{data_key}"]

          value =
            case data_type do
              :string -> "#{form_input}"
            end

          {data_key, value}
        end)
        |> Enum.into(%{})
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
