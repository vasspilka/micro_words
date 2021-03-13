defmodule MicroWords.Rulesets.Basic do
  alias MicroWords.Worlds.{Location, World}
  alias MicroWords.Explorers.{Explorer, Journey}
  alias MicroWords.{Action, Artefact}

  alias MicroWords.Ruleset.Actions.BasicArtefact

  @action_modules [
    BasicArtefact.ForgeNote,
    BasicArtefact.PlantArtefact,
    BasicArtefact.SupportArtefact,
    BasicArtefact.WeakenArtefact
    # Protect Artefact:
    # Disenchant Artefact:
    # ? Leach Artefact: (artefact -> explorer)
  ]

  use MicroWords.Ruleset,
    dimensions: [100, 100],
    action_modules: @action_modules

  @impl true
  def initial_energy(%Explorer{}), do: 200_000
end
