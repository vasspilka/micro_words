defmodule MicroWords.Rulesets.Action do
  use TypedStruct

  @ruleset_module Application.get_env(:micro_words, :ruleset_module)

  typedstruct do
    field :type, @ruleset_module.action_types()
    field :explorer_id, binary()
    field :artefact_id, binary()
    field :location_id, binary()
    field :data, binary()
    field :ruleset, module()
  end
end
