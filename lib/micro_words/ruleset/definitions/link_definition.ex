defmodule MicroWords.Ruleset.Definitions.LinkDefinition do
  @moduledoc """
  Link definition helps to define links for use in rulesets.

  Fields Documentation:

  - name: The name is used to identify a link. Rulesets must not have more than
  one link with the same name.

  """
  use TypedStruct

  typedstruct do
    field(:name, atom())
  end

  defmacro __using__(definition) do
    quote do
      @link_name @definition.name

      def definition, do: @definition
    end
  end
end
