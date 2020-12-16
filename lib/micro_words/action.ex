defmodule MicroWords.Action do
  use TypedStruct

  @type progress :: :drafted | :taken | :passed | :failed

  # todo make this dynamic
  @ruleset_module MicroWords.Rulesets.Basic

  @derive Jason.Encoder
  typedstruct do
    field :type, @ruleset_module.action_type()
    field :explorer_id, binary()
    field :artefact_id, binary()
    field :location_id, binary()
    field :data, map()
    field :ruleset, module()
    field :progress, progress(), default: :drafted
    field :cost, integer(), default: 0
  end
end
