defmodule MicroWords.Locations.Commands do

  # Since this will be called often we should create cached view
  # the cached view can be updated as projection.
  defmodule Get do
    defstruct [:location_id]
  end

  defmodule Forge do
    defstruct [:id, :explorer_id, :world, :item, :content]
  end

  defmodule React do
    defstruct [:id, :explorer_id, :world, :action]
  end
end
