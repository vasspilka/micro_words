defmodule MicroWords.Rulesets.Default do
  # TODO: rename to Basic and make it so that other rulesets can extend basic
  alias MicroWords.Worlds.Location
  alias MicroWords.Artefact
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Explorers.Journey
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
    artefact = %Artefact{
      id: act.artefact_id,
      originator: o.id,
      world: o.world,
      energy: @artefact_energy_cost,
      content: act.data.content
    }

    %Explorer{
      o
      | energy: o.energy - @artefact_energy_cost,
        artefacts: Map.put(o.artefacts, act.artefact_id, artefact)
    }
  end

  def is_valid?(%Explorer{energy: energy}, %Action{type: :forge_artefact}) do
    energy >= @artefact_energy_cost
  end

  # PlantArtefact
  def reaction(%Journey{} = journey, %Action{type: :plant_artefact}) do
    # TODO
    []
  end

  def apply(%Explorer{} = o, %Action{type: :plant_artefact} = act) do
    # TODO: actually should be on UserAffected after we confirm it was placed
    %Explorer{o | artefacts: Map.delete(o.artefacts, act.data.artefact.id)}
  end

  def is_valid?(%Explorer{}, %Action{type: :plant_artefact}) do
    true
  end

  # BoostArtefact
  def reaction(%Journey{explorer_id: _id}, %Action{type: :boost_artefact}) do
    []
  end

  def apply(%Explorer{} = o, %Action{type: :boost_artefact}) do
    %Explorer{o | energy: o.energy - 20}
  end

  # maybe we can use norm to validate if an action can be taken
  # would be also usefull if we want to do property testing with
  # actions
  def is_valid?(%Explorer{energy: energy}, %Action{type: :boost_artefact}) do
    energy > 20
  end

  # ImpairArtefact
  # TODO: Would harm artefact to kill it

  @spec build_action(Explorer.t(), action_type(), map()) :: Action.t()
  def build_action(explorer, :forge_artefact, %{content: content}) do
    %Action{
      type: :forge_artefact,
      artefact_id: UUID.uuid4(),
      explorer_id: explorer.id,
      location_id: Location.id_from_attrs(explorer),
      ruleset: __MODULE__,
      data: %{content: content}
    }
  end

  def build_action(explorer, :plant_artefact, %{artefact_id: artefact_id}) do
    %Action{
      type: :plant_artefact,
      artefact_id: artefact_id,
      explorer_id: explorer.id,
      location_id: Location.id_from_attrs(explorer),
      ruleset: __MODULE__,
      data: %{artefact: explorer.artefacts[artefact_id]}
    }
  end
end
