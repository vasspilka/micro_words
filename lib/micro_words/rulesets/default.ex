defmodule MicroWords.Rulesets.Default do
  alias MicroWords.Worlds.Explorers.Explorer
  alias MicroWords.Worlds.Explorers.Journey
  # alias MicroWords.Worlds.Artefacts.Artefact
  alias MicroWords.Rulesets.Action

  # Actions
  # alias MicroWords.Worlds.Artefacts.Commands.Forge
  alias MicroWords.Worlds.Artefacts.Commands.React

  @type action_types :: :forge_artefact | :boost_artefact | :impair_artefact

  @spec dimensions() :: {integer(), integer()}
  def dimensions() do
    {100, 100}
  end

  def initial_energy(%Explorer{}) do
    200
  end

  # ForgeArtefact
  def reaction(%Journey{explorer_id: id}, %Action{action_name: :forge_artefact} = action) do
    # %{world: world, explorer_id: id, context: %{text: text}} = action
    # %ForgeArtefact{id: UUID.uuid4(), world: world, explorer_id: id, content: text}
  end

  def apply(%Explorer{} = o, %Action{action_name: :forge_artefact}) do
    %Explorer{energy: o.energy - 40}
  end

  def valid_for?(%Explorer{energy: energy}, %Action{action_name: "spawn_artefact"}) do
    energy >= 40
  end

  # BoostArtefact
  def reaction(%Journey{explorer_id: id}, %Action{action_name: :boost_artefact} = action) do
    %{world: world, explorer_id: id, context: %{text: text}} = action
    %React{id: UUID.uuid4(), world: world, explorer_id: id}
  end

  def apply(%Explorer{} = o, %Action{action_name: "spawn_artefact"}) do
    %Explorer{energy: o.energy + 40}
  end

  def valid_for?(%Explorer{energy: energy}, %Action{action_name: "spawn_artefact"}) do
    true
  end

  # ImpairArtefact
  #

  @spec build_action(Explorer.t(), action_type(), map()) :: Action.t()
  def build_action(explorer, :forge_artefact, %{content: content}) do
    {x, y} = explorer.location
    location_id = "{#{x},#{y}:#{explorer.world}}"

    %Action{
      type: :forge_artefact,
      explorer_id: explorer.id,
      location_id: location_id,
      ruleset: __MODULE__,
      data: data
    }
  end
end
