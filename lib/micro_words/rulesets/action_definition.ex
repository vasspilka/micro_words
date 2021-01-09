defmodule MicroWords.Ruleset.ActionDefinition do
  use TypedStruct

  alias MicroWords.Ruleset

  typedstruct module: Reward do
    field :xp, integer(), default: 0
    field :energy, integer(), default: 0
  end

  @type data_form :: %{atom() => atom()}
  @type action_data :: map()

  typedstruct do
    field :name, atom()
    field :cost, integer()
    field :reward, Reward.t()
    field :data_form, data_form()
    # can be used to validate action if available
    field :availability, Ruleset.availability_fn()
    field :on_build, Ruleset.on_build_fn()
    field :on_action_taken, Ruleset.on_action_taken_fn()
    # , default: fn _, _ -> [] end
    field :world_reaction, Ruleset.world_reaction_fn()
    # , default: fn _, _ -> [] end
    field :affects, Ruleset.affects_fn()
  end
end
