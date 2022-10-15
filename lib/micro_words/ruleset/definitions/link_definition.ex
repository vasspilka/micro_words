defmodule MicroWords.Ruleset.Definitions.LinkDefinition do
  @moduledoc """
  Link definition helps to define links for use in rulesets.

  Fields Documentation:

  - name: The name is used to identify a link. Rulesets must not have more than
  one link with the same name.

  """
  use TypedStruct

  alias MicroWords.Worlds.Link

  typedstruct do
    field(:name, atom())
  end

  defmacro __using__(definition) do
    quote do
      @definition unquote(definition)
      @link_name @definition.name

      def definition, do: @definition

      def build(entity, _data \\ %{}) do
        %Link{
          type: @definition.name,
          links_to: %{id: entity.id, type: entity.__struct__}
        }

        # validated_data = validate_data_form(data)

        # entity
        # |> on_build(validated_data)
        # |> Enum.reduce(
        #   fn {k, v}, action ->
        #     Map.replace(action, k, v)
        #   end
        # )
      end
    end
  end

  defmacro __before_compile__(_env) do
    quote do
      def on_build(_, _), do: []
    end
  end
end
