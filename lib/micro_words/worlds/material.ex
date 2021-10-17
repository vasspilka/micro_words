defmodule MicroWords.Worlds.Material do
  @moduledoc """
  An material is a piece of content.
  """

  use TypedStruct

  alias MicroWords.Worlds.Link

  # Maybe dynamic definition based on rulesets
  @type material_type() :: :note

  typedstruct do
    field :type, material_type()
    field :id, binary()
    field :content, binary()
    field :world, binary()
    field :links, [Link.t()], default: []
    field :energy, integer(), default: 0
    field :state, integer(), default: 0
    field :gen, integer(), default: 0
  end
end
