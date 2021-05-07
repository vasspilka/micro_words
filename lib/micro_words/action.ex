defmodule MicroWords.Action do
  use TypedStruct

  alias MicroWords.Ruleset.ActionDefinition

  @type progress :: :drafted | :taken | :passed | :failed

  # todo make this dynamic
  # @ruleset_module MicroWords.Rulesets.Basic
  # @ruleset_module.action_type()

  @derive Jason.Encoder
  typedstruct do
    field :type, atom()
    field :ruleset, module()
    field :explorer_id, binary()
    field :artefact_id, binary()
    field :location_id, binary()
    # TODO change to input_data
    field :data, map(), default: %{}
    # result to affect the explorer on action taken usefull for location change
    field :result, map(), default: %{}
    field :reward, ActionDefinition.Reward.t(), default: %ActionDefinition.Reward{}
    field :progress, progress(), default: :drafted
    field :cost, integer(), default: 0
  end
end
