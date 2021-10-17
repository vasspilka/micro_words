defmodule MicroWords.Worlds.Link do
  use TypedStruct

  typedstruct do
    @moduledoc """
    A link to explorers, other materials or locations.

    Links are used in order to identify how and with what an material is linked.
    As an material received actions reactions can occur to linked objects.

    The link type helps us identify the reason of the link
    as well as the type of the linked entity.
    """
    field :id, binary()
    field :type, atom()
  end
end
