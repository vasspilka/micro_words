defmodule MicroWords.Artefact do
  @moduledoc """
  An artefact is a piece of content.
  """

  use TypedStruct

  typedstruct module: Link do
    @moduledoc """
    A link to explorers, other artefacts or locations.

    Links are used in order to identify how and with what an artefact is linked.
    As an artefact received actions reactions can occur to linked objects.

    The link type helps us identify the reason of the link
    as well as the type of the linked entity.
    """
    field :id, binary()
    field :type, atom()
  end

  # Maybe dynamic definition based on rulesets
  @type artefact_type() :: :note

  typedstruct do
    field :type, artefact_type()
    field :id, binary()
    field :content, binary()
    field :world, binary()
    # TODO: Maybe link
    field :originator, binary()
    field :links, [Link.t()], default: []
    field :energy, integer(), default: 0
    field :state, integer(), default: 0
    field :gen, integer(), default: 0
  end
end
