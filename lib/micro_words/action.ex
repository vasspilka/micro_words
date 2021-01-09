defmodule MicroWords.Action do
  use TypedStruct

  alias MicroWords.Ruleset.ActionDefinition

  @type progress :: :drafted | :taken | :passed | :failed

  # todo make this dynamic
  @ruleset_module MicroWords.Rulesets.Basic

  @derive Jason.Encoder
  typedstruct do
    field :type, @ruleset_module.action_type()
    field :ruleset, module()
    field :explorer_id, binary()
    field :artefact_id, binary()
    field :location_id, binary()
    field :data, map(), default: %{}
    # possible result to affect the explorer on action taken
    # could be usefull for location change or other
    # field :result, map(), default: %{}
    field :reward, ActionDefinition.Reward.t(), default: %ActionDefinition.Reward{}
    field :progress, progress(), default: :drafted
    field :cost, integer(), default: 0
  end
end
