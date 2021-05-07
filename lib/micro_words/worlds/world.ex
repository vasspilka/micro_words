defmodule MicroWords.Worlds.World do
  use TypedStruct

  alias MicroWords.Worlds.World

  alias MicroWords.Commands.{
    ViewWorld,
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

  def execute(%World{name: name}, %ViewWorld{name: name}) when not is_nil(name),
    do: []

  def execute(%World{}, %CreateWorld{}), do: []

  def apply(%World{}, %WorldCreated{} = evt) do
    %World{
      name: evt.name,
      ruleset: evt.ruleset
    }
  end
end
