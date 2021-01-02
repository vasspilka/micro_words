defmodule MicroWords.Ruleset.Actions do
  defmacro __using__(_opts) do
    quote do
      import MicroWords.Ruleset.Actions
    end
  end

  defmacro defaction(action_name, input, block) do
  end

  defmacro on_build(block) do
  end

  defmacro on_action_taken(function) do
  end

  defmacro valid_when(entity_type, function) do
  end

  defmacro reaction(entity_type, affect: other_entity_type) do
  end

  defmacro affects(entity_type, function) do
  end
end
