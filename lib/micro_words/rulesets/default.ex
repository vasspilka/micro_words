defmodule MicroWords.Rulesets.Default do
  alias MicroWords.Worlds.Explorers.Explorer
  alias MicroWords.Worlds.Explorers.Journey
  alias MicroWords.Worlds.Artefacts.Artefact
  alias MicroWords.Rulesets.Action

  # Actions
  alias MicroWords.Worlds.Artefacts.Commands.Forge
  alias MicroWords.Worlds.Artefacts.Commands.React

  def initial_energy(%Explorer{}) do
    200
  end

  # ForgeArtefact
  def reaction(%Journey{explorer_id: id}, %Action{action_name: "forge_artefact"} = action) do
    %{world: world, explorer_id: id, context: %{text: text}} = action
    %ForgeArtefact{id: UUID.uuid4(), world: world, explorer_id: id, content: text}
  end

  def apply(%Explorer{} = o, %Action{action_name: "spawn_artefact"}) do
    %Explorer{energy: o.energy - 40}
  end

  def valid_for?(%Explorer{energy: energy}, %Action{action_name: "spawn_artefact"}) do
    energy >= 40
  end

  # ViewArtefact
  def reaction(%Journey{explorer_id: id}, %Action{action_name: "view_artefact"} = action) do
    %{world: world, explorer_id: id, context: %{text: text}} = action
    %React{id: UUID.uuid4(), world: world, explorer_id: id, content: text}
  end

  def apply(%Explorer{} = o, %Action{action_name: "spawn_artefact"}) do
    %Explorer{energy: o.energy + 40}
  end

  def valid_for?(%Explorer{energy: energy}, %Action{action_name: "spawn_artefact"}) do
    true
  end

  # BoostArtefact

  # ImpairArtefact
end
