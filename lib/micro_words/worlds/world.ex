defmodule MicroWords.Worlds.World do
  use TypedStruct

  alias MicroWords.Worlds.World

  alias MicroWords.Commands.{
    CreateWorld
  }

  alias MicroWords.Events.{
    WorldCreated
  }

  typedstruct do
    field :name, binary()
    field :ruleset, module()
  end

  def execute(%World{name: nil}, %CreateWorld{} = cmd) do
    %WorldCreated{
      name: cmd.name,
      ruleset: cmd.ruleset
    }
  end

  def execute(%World{}, %CreateWorld{}), do: []

  def apply(%World{}, %WorldCreated{} = evt) do
    %World{
      name: evt.name,
      ruleset: evt.ruleset
    }
    |> IO.inspect()
  end
end
