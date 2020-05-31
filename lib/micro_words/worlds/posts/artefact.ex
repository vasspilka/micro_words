defmodule MicroWords.Worlds.Artefacts.Artefact do
  alias MicroWords.Worlds.Artefacts.Artefact

  alias MicroWords.Worlds.Artefacts.Commands.{
    Spawn,
    ReceiveAction
  }

  alias MicroWords.Events.{
    ArtefactForged,
    ArtefactReceivedAction
  }

  defstruct [
    :id,
    :world,
    :explorer_id,
    :type,
    :content,
    :energy,
    :state
  ]

  def execute(%Artefact{id: nil}, %Spawn{} = cmd) do
    %ArtefactForged{
      id: cmd.id,
      explorer_id: cmd.explorer_id,
      world: cmd.world,
      content: cmd.content
    }
  end

  def execute(%Artefact{id: id} = state, %ReceiveAction{id: id} = cmd) do
    %ArtefactReceivedAction{
      id: id,
      world: cmd.world,
      explorer_id: cmd.explorer_id,
      action: cmd.action
    }
  end

  def apply(%Artefact{}, %ArtefactForged{} = evt) do
    %Artefact{
      id: evt.id,
      world: evt.world,
      explorer_id: evt.explorer_id
    }
    |> set_energy()
  end

  def apply(%Artefact{} = state, %ArtefactReceivedAction{} = evt) do
    apply_action(state, evt)
  end

  defp set_energy(artefact) do
    %Artefact{
      artefact
      | energy: 100
    }
  end

  defp apply_action(artefact, _evt) do
    artefact
  end
end
