defmodule MicroWords.Rulesets.Default do
  # TODO: rename to Basic and make it so that other rulesets can extend basic
  alias MicroWords.Action
  alias MicroWords.Artefact
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Explorers.Journey
  alias MicroWords.Worlds.Location

  alias MicroWords.Events.{
    ExplorerActionTaken,
    ExplorerAffected,
    LocationAffected
  }

  alias MicroWords.Worlds.Commands.AffectLocation
  # alias MicroWords.Explorers.Commands.Affect, as: AffectExplorer

  @type action_type :: :forge_artefact | :plant_arteface | :boost_artefact | :impair_artefact

  @artefact_energy_cost 40

  @spec dimensions() :: {integer(), integer()}
  def dimensions() do
    [100, 100]
  end

  def initial_energy(%Explorer{}) do
    200
  end

  def apply(%Explorer{} = o, %ExplorerActionTaken{action: %{type: :forge_artefact} = act}) do
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

  def apply(%Explorer{} = o, %ExplorerAffected{
        action: %{type: :plant_artefact, progress: :passed} = act
      }) do
    %Explorer{o | artefacts: Map.delete(o.artefacts, act.data.artefact.id)}
  end

  def apply(%Location{} = o, %LocationAffected{action: %{type: :plant_artefact} = act}) do
    %Location{o | artefact: act.data.artefact}
  end

  # def apply(%Explorer{} = o, %Action{type: :boost_artefact}) do
  #   %Explorer{o | energy: o.energy - 20}
  # end

  def apply(o, _), do: o

  def reaction(%Journey{}, %ExplorerActionTaken{action: %{type: :plant_artefact} = act}) do
    %AffectLocation{location_id: act.location_id, action: act}
  end

  def reaction(%Journey{}, %ExplorerActionTaken{}) do
    []
  end

  def react(%Location{artefact: nil}, %AffectLocation{action: %{type: :plant_artefact} = act}) do
    %LocationAffected{id: act.location_id, action: %{act | progress: :passed}}
  end

  def react(%Location{}, %AffectLocation{action: %{type: :plant_artefact}}) do
    {:error, :location_not_empty}
  end

  # maybe we can use norm to validate if an action can be taken
  # would be also usefull if we want to do property testing with
  # actions
  def is_valid?(%Explorer{energy: energy}, %Action{type: :forge_artefact}) do
    energy >= @artefact_energy_cost
  end

  def is_valid?(%Explorer{}, %Action{type: :plant_artefact}) do
    true
  end

  def is_valid?(%Explorer{energy: energy}, %Action{type: :boost_artefact}) do
    energy > 20
  end

  # BoostArtefact: Would give energy to artefact
  # ImpairArtefact: Would harm artefact to destroy it

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
