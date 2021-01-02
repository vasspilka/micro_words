defmodule MicroWords.Ruleset.Actions.BasicArtefact do
  use MicroWords.Ruleset.Actions

  defaction :forge_note, cost: 20, data: %{content: :string} do
    on_build(fn _exlorer, _action ->
      [artefact_id: UUID.uuid4()]
    end)

    on_action_taken(fn exlorer, action ->
      artefact = %Artefact{
        id: action.artefact_id,
        originator: explorer.id,
        world: explorer.world,
        energy: action.cost,
        content: action.data.content
      }

      [artefacts: Map.put(explorer.artefacts, action.artefact_id, artefact)]
    end)
  end

  defaction :place_artefact, cost: 0, data: %{artefact_id: :string} do
    valid_when(:exlorer, fn exlorer, action ->
      exlorer.artefacts
      |> Map.keys()
      |> Enum.member?(action.artefact_id)
    end)

    reaction(:journey, affect: :location)

    affects(:location, fn %{artefact: nil}, action ->
      [artefact: action.data.artefact]
    end)

    affects(:explorer, fn explorer, action ->
      [artefacts: Map.delete(explorer.artefacts, action.artefact_id)]
    end)
  end

  defaction :boost_artefact, cost: 10, data: %{artefact_id: :string} do
    reaction(:journey, affect: :location)

    affects(:location, fn %{artefact: %{id: artefact_id} = artefact},
                          %{artefact_id: artefact_id} ->
      [artefact: %{energy: artefact.energy + action.cost}]
    end)
  end

  defaction :chop_artefact, cost: 15, data: %{artefact_id: :string} do
    reaction(:journey, affect: :location)

    affects(:location, fn %{artefact: %{id: artefact_id} = artefact},
                          %{artefact_id: artefact_id} ->
      [
        artefact: %{energy: artefact.energy - 10},
        ground: %{energy: loc.energy + 25}
      ]
    end)
  end
end
