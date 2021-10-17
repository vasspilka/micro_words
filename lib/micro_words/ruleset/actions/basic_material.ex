defmodule MicroWords.Ruleset.Actions.BasicMaterial do
  @moduledoc """
  Actions that involve the creation and basic interaction between explorers and materials.
  """

  alias MicroWords.Explorers.Action
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Link
  alias MicroWords.Worlds.Material
  alias MicroWords.Ruleset.Definitions.ActionDefinition
  alias MicroWords.Worlds.Location

  alias ActionDefinition.Reward
  alias ActionDefinition.WorldReaction

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
      data_form: %{
        content: :string
      }
    }

    def on_build(_explorer, %{}) do
      [material_id: UUID.uuid4()]
    end

    def on_action_taken(%Explorer{} = o, act) do
      material = %Material{
        type: :note,
        id: act.material_id,
        links: [%Link{type: :originator, id: o.id}],
        world: o.world,
        energy: act.cost,
        content: act.input_data.content
      }

      [materials: Map.put(o.materials, act.material_id, material)]
    end
  end

  defmodule PlantMaterial do
    use ActionDefinition, %ActionDefinition{
      name: :plant_material,
      type: :reactive,
      description: "Places selected material to location.",
      data_form: %{material_id: :string},
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

    def on_build(explorer, %{material_id: material_id}) do
      [
        material_id: material_id,
        input_data: %{material: explorer.materials[material_id]}
      ]
    end

    def on_validate(%Explorer{materials: materials}, act) do
      materials
      |> Map.keys()
      |> Enum.member?(act.material_id)
      |> if do
        :ok
      else
        {:error, :inexistent_material}
      end
    end

    def on_validate(%Location{material: nil}, _act), do: :ok
    def on_validate(%Location{}, _act), do: {:error, :location_has_material}

    def affects(%Explorer{} = o, %Action{progress: :passed} = act) do
      [materials: Map.delete(o.materials, act.input_data.material.id)]
    end

    def affects(%Location{material: nil}, act) do
      [material: act.input_data.material]
    end
  end

  defmodule SupportMaterial do
    use ActionDefinition, %ActionDefinition{
      name: :support_material,
      base_cost: 10,
      type: :reactive,
      description: "Supports current material giving it some energy.",
      data_form: %{material_id: :string},
      world_reactions: [
        %WorldReaction{
          from: ExplorerActionTaken,
          agent: Journey,
          affects: AffectLocation
        }
      ]
    }

    def on_validate(%Location{material: material}, act) do
      if material.id == act.material_id do
        :ok
      else
        {:error, :bad_material}
      end
    end

    def on_build(_explorer, %{material_id: material_id}) do
      [material_id: material_id]
    end

    def affects(%Location{material: material}, act) do
      [material: %{material | energy: material.energy + act.cost}]
    end
  end

  defmodule WeakenMaterial do
    use ActionDefinition, %ActionDefinition{
      name: :weaken_material,
      base_cost: 15,
      type: :reactive,
      description: "Weakens material on location taking away some energy.",
      data_form: %{material_id: :string},
      world_reactions: [
        %WorldReaction{
          from: ExplorerActionTaken,
          agent: Journey,
          affects: AffectLocation
        }
      ]
    }

    def on_build(_explorer, %{material_id: material_id}) do
      [material_id: material_id]
    end

    def on_validate(%Location{material: material}, act) do
      if material.id == act.material_id do
        :ok
      else
        {:error, :bad_material}
      end
    end

    def affects(%Location{material: material, ground: ground}, act) do
      [
        material: %{material | energy: material.energy - 10},
        ground: %{ground | energy: ground.energy + act.cost + 10}
      ]
    end
  end

  # TODO
  # defmodule CopyMaterial do
  # end
end
