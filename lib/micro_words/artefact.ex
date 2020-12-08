defmodule MicroWords.Artefact do
  @moduledoc """
  An artefact is a piece of content.
  Usually it is an embedded
  """

  use TypedStruct

  typedstruct do
    field :id, binary()
    field :content, binary()
    field :world, binary()
    field :originator, binary()
    field :gen, integer(), default: 0
  end
end
