defmodule MicroWords.Events do
  defmodule WorldCreated do
    @derive Jason.Encoder
    defstruct [:name, :energy, :ruleset]
  end

  defmodule ExplorerEnteredWorld do
    @derive Jason.Encoder
    defstruct [:id, :world, :location]
  end

  defmodule ExplorerReceivedRuleset do
    @derive Jason.Encoder
    defstruct [:id, :ruleset]
  end

  defmodule ExplorerMoved do
    @derive Jason.Encoder
    defstruct [:id, :world, :location]
  end

  defmodule ExplorerActionTaken do
    @derive Jason.Encoder
    defstruct [:id, :world, :action, :data]
  end

  defmodule ExplorerAffected do
    @derive Jason.Encoder
    defstruct [:id, :action]
  end

  defmodule ArtefactForged do
    @derive Jason.Encoder
    defstruct [:location_id, :explorer_id, :content]
  end

  defmodule ArtefactAffected do
    @derive Jason.Encoder
    defstruct [:id, :world, :explorer_id, :action]
  end
end
