defmodule MicroWords.Worlds.Material do
  @moduledoc """
  An material is a piece of content.
  """

  use TypedStruct

  alias MicroWords.Worlds.Link
  alias MicroWords.Worlds.Material

  typedstruct do
    field :type, module()
    field :id, binary()
    field :content, binary()
    field :world, binary()
    field :links, [Link.t()], default: []
    field :state, map(), default: %{}
  end

  @type apply_types :: :give_energy | :remove_energy

  def build(
        %{
          type: material_module,
          id: id,
          content: content,
          links: links,
          world: world
        },
        act
      ) do
    %Material{
      type: material_module,
      id: id,
      content: content,
      links: links,
      world: world,
      state: %{energy: act.cost}
    }
  end

  def give_energy() do
  end
end
