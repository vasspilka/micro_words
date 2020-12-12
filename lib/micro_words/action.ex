defmodule MicroWords.Action do
  use TypedStruct

  @type progress :: :drafted | :taken | :passed | :failed

  @ruleset_module Application.get_env(:micro_words, :ruleset_module)

  @derive Jason.Encoder
  typedstruct do
    field :type, @ruleset_module.action_types()
    field :explorer_id, binary()
    field :artefact_id, binary()
    field :location_id, binary()
    field :data, binary()
    field :ruleset, module()
    field :progress, progress(), default: :drafted
  end
end
