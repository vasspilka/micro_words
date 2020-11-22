defmodule MicroWords.Events do
  defmodule WorldCreated do
    @derive Jason.Encoder
    defstruct [:name, :energy, :ruleset]
  end

  defmodule ExplorerEnteredWorld do
    @derive Jason.Encoder
    defstruct [:id, :world, :starting_position]
  end

  defmodule ExplorerReceivedRuleset do
    @derive Jason.Encoder
    defstruct [:id, :ruleset]
  end

  defmodule ExplorerActionTaken do
    @derive Jason.Encoder
    defstruct [:id, :world, :action, :data]
  end

  defmodule ExplorerAffected do
    @derive Jason.Encoder
    defstruct [:id, :action, :data]
  end

  defmodule ExplorerMoved do
    @derive Jason.Encoder
    defstruct [:id, :world, :direction]
  end

  defmodule ArtefactForged do
    @derive Jason.Encoder
    defstruct [:id, :world, :explorer_id, :content]
  end

  defmodule ArtefactReceivedAction do
    @derive Jason.Encoder
    defstruct [:id, :world, :explorer_id, :action]
  end
end
