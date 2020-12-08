defmodule MicroWords.Rulesets.Default do
  # TODO: rename to Basic and make it so that other rulesets can extend basic
  alias MicroWords.Artefact
  alias MicroWords.Worlds.Explorers.Explorer
  alias MicroWords.Worlds.Explorers.Journey
  alias MicroWords.Rulesets.Action

  # Actions
  # alias MicroWords.Worlds.Artefacts.Commands.Forge
  # alias MicroWords.Worlds.Artefacts.Commands.React

  @type action_type :: :forge_artefact | :plant_arteface | :boost_artefact | :impair_artefact

  @artefact_energy_cost 40

  @spec dimensions() :: {integer(), integer()}
  def dimensions() do
    {100, 100}
  end

  def initial_energy(%Explorer{}) do
    200
  end

  # ForgeArtefact
  def reaction(%Journey{} = journey, %Action{type: :forge_artefact}) do
    []
  end

  def apply(%Explorer{} = o, %Action{type: :forge_artefact} = act) do
    artefact_id = UUID.uuid4()

    artefact = %Artefact{
      id: artefact_id,
      originator: o.id,
      world: o.world,
      energy: @artefact_energy_cost,
      content: act.data.content
    }

    %Explorer{
      energy: o.energy - @artefact_energy_cost,
      artefacts: Map.put(o.artefacts, artefact_id, artefact)
    }
  end

  def valid_for?(%Explorer{energy: energy}, %Action{type: :forge_artefact}) do
    energy >= @artefact_energy_cost
  end

  # PlantArtefact
  def reaction(%Journey{} = journey, %Action{type: :plant_artefact}) do
    # TODO
    []
  end

  def apply(%Explorer{} = o, %Action{type: :plant_artefact} = act) do
    # TODO: actually should be on UserAffected after we confirm it was placed
    artefact_id = act.data.artefact_id

    %Explorer{artefacts: Map.drop(o.artefacts, artefact_id)}
  end

  def valid_for?(%Explorer{}, %Action{type: :plant_artefact}) do
    true
  end

  # BoostArtefact
  def reaction(%Journey{explorer_id: _id}, %Action{type: :boost_artefact}) do
    []
  end

  def apply(%Explorer{} = o, %Action{type: :boost_artefact}) do
    %Explorer{energy: o.energy - 20}
  end

  def valid_for?(%Explorer{energy: energy}, %Action{type: :boost_artefact}) do
    energy > 20
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
      data: %{content: content}
    }
  end
end
