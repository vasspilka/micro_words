defmodule MicroWords.Worlds.World do
  alias MicroWords.Worlds.World

  alias MicroWords.Worlds.Commands.{
    CreateWorld,
    Touch
  }

  alias MicroWords.Events.{
    WorldCreated
  }

  defstruct [
    :name,
    # :energy,
    ruleset: %{}
  ]

  def execute(%World{name: nil}, %CreateWorld{} = cmd) do
    %WorldCreated{
      name: cmd.name,
      # energy: energy_from_ruleset(cmd.ruleset),
      ruleset: cmd.ruleset
    }
  end

  def execute(%World{}, %Touch{}), do: []

  def apply(%World{}, %WorldCreated{} = evt) do
    %World{
      name: evt.name,
      # energy: evt.energy,
      ruleset: evt.ruleset
    }
  end

  # def energy_from_ruleset(ruleset) do
  #   100
  # end
end
