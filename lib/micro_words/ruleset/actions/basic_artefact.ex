defmodule MicroWords.Ruleset.Actions.BasicArtefact do
  alias MicroWords.Ruleset.ActionDefinition
  alias MicroWords.Ruleset.ActionDefinition.Reward
  alias MicroWords.Ruleset.ActionDefinition.WorldReaction

  alias MicroWords.Action
  alias MicroWords.Artefact
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Location

  alias MicroWords.Events.{
    ExplorerActionTaken,
    LocationAffected
  }

  alias MicroWords.Commands.{
    AffectLocation,
    AffectExplorer
  }

  defmodule ForgeNote do
    use ActionDefinition, %ActionDefinition{
      name: :forge_note,
      type: :simple,
      base_cost: 20,
      reward: %Reward{
        xp: 10
      },
      description: "Creates a small note. Up to 80 characters.",
      key_binding: "m",
      data_form: %{
        content: :string
      }
    }

    def on_build(_explorer, %{content: _content}) do
      [artefact_id: UUID.uuid4()]
    end

    def on_action_taken(%Explorer{} = o, act) do
      artefact = %Artefact{
        type: :note,
        id: act.artefact_id,
        originator: o.id,
        world: o.world,
        energy: act.cost,
        content: act.data.content
      }

      [artefacts: Map.put(o.artefacts, act.artefact_id, artefact)]
    end
  end

  defmodule PlantArtefact do
    use ActionDefinition, %ActionDefinition{
      name: :plant_artefact,
      type: :reactive,
      description: "Places selected artefact to location.",
      key_binding: "p",
      data_form: %{artefact_id: :string},
      world_reactions: [
        %WorldReaction{
          from: ExplorerActionTaken,
          agent: Journey,
          affects: AffectLocation
        },
        %WorldReaction{
          from: LocationAffected,
          agent: Journey,
          affects: AffectExplorer
        }
      ]
    }

    def on_build(explorer, %{artefact_id: artefact_id}) do
      [
        artefact_id: artefact_id,
        data: %{artefact: explorer.artefacts[artefact_id]}
      ]
    end

    def on_validate(%Explorer{artefacts: artefacts}, act) do
      artefacts
      |> Map.keys()
      |> Enum.member?(act.artefact_id)
      |> if do
        :ok
      else
        {:error, :inexistent_artefact}
      end
    end

    def on_validate(%Location{artefact: nil}, _act), do: :ok
    def on_validate(%Location{}, _act), do: {:error, :location_has_artefact}

    def affects(%Explorer{} = o, %Action{progress: :passed} = act) do
      [artefacts: Map.delete(o.artefacts, act.data.artefact.id)]
    end

    def affects(%Location{artefact: nil}, act) do
      [artefact: act.data.artefact]
    end
  end

  defmodule SupportArtefact do
    use ActionDefinition, %ActionDefinition{
      name: :support_artefact,
      base_cost: 10,
      type: :reactive,
      description: "Supports current artefact giving it some energy.",
      key_binding: "g",
      data_form: %{artefact_id: :string},
      world_reactions: [
        %WorldReaction{
          from: ExplorerActionTaken,
          agent: Journey,
          affects: AffectLocation
        }
      ]
    }

    def on_validate(%Location{artefact: artefact}, act) do
      if artefact.id == act.artefact_id do
        :ok
      else
        {:error, :bad_artefact}
      end
    end

    def on_build(_explorer, %{artefact_id: artefact_id}) do
      [artefact_id: artefact_id]
    end

    def affects(%Location{artefact: artefact}, act) do
      [artefact: %{artefact | energy: artefact.energy + act.cost}]
    end
  end

  defmodule WeakenArtefact do
    use ActionDefinition, %ActionDefinition{
      name: :weaken_artefact,
      base_cost: 15,
      type: :reactive,
      description: "Weakens artefact on location taking away some energy.",
      key_binding: "k",
      data_form: %{artefact_id: :string},
      world_reactions: [
        %WorldReaction{
          from: ExplorerActionTaken,
          agent: Journey,
          affects: AffectLocation
        }
      ]
    }

    def on_build(_explorer, %{artefact_id: artefact_id}) do
      [artefact_id: artefact_id]
    end

    def on_validate(%Location{artefact: artefact}, act) do
      if artefact.id == act.artefact_id do
        :ok
      else
        {:error, :bad_artefact}
      end
    end

    def affects(%Location{artefact: artefact, ground: ground}, act) do
      [
        artefact: %{artefact | energy: artefact.energy - 10},
        ground: %{ground | energy: ground.energy + act.cost + 15}
      ]
    end
  end

  # TODO
  defmodule CopyArtefact do
  end
end
