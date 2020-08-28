defmodule MicroWords.Worlds.Artefacts.Commands do
  defmodule Forge do
    defstruct [:id, :explorer_id, :world, :item, :content]
  end

  defmodule React do
    defstruct [:id, :explorer_id, :world, :action]
  end
end
