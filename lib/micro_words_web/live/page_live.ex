defmodule MicroWordsWeb.PageLive do
  use MicroWordsWeb, :live_view

  alias MicroWords.Explorers
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Location

  @impl true
  def mount(_params, _session, socket) do
    # TODO: Get or create exlorer from socket.
    {:ok, explorer} = MicroWords.Explorers.enter_world("dev_user", "dev_world")

    # _world = socket.private.connect_params["world"]
    # _explorer_id = socket.private.connect_params["explorer_uuid"]
    #

    :ok = MicroWordsWeb.Endpoint.subscribe("explorer:#{explorer.id}")

    location_id = Location.id_from_attrs(explorer)
    {:ok, location} = Worlds.get_location(location_id)

    :ok = MicroWordsWeb.Endpoint.subscribe("location:#{location_id}")

    {:ok,
     assign(socket,
       explorer: explorer,
       location_id: location_id,
       location: location,
       action_definitions: explorer.ruleset.action_definitions(%{})
     )}
  end

  @impl true
  def handle_event("explorer-action", %{"action" => action, "data" => data}, socket)
      when is_binary(action) do
    action_name = String.to_atom(action)

    {:ok, explorer, _} = Explorers.take_action(socket.assigns.explorer.id, action_name, data)

    new_location_id = Location.id_from_attrs(explorer)

    {:ok, location} =
      case socket.assigns.location_id do
        ^new_location_id ->
          {:ok, socket.assigns.location}

        old_location_id ->
          :ok = MicroWordsWeb.Endpoint.unsubscribe("location:#{old_location_id}")
          :ok = MicroWordsWeb.Endpoint.subscribe("location:#{new_location_id}")

          Worlds.get_location(new_location_id)
      end

    {:noreply,
     assign(socket,
       explorer: explorer,
       location_id: new_location_id,
       location: location
     )}
  end

  def handle_event("explorer-action", %{"action" => action}, socket) do
    handle_event("explorer-action", %{"action" => action, "data" => %{}}, socket)
  end

  @impl true
  def handle_info(%{event: "explorer_affected", payload: explorer}, socket) do
    {:noreply, assign(socket, explorer: explorer)}
  end

  def handle_info(%{event: "location_affected", payload: location}, socket) do
    {:noreply, assign(socket, location: location)}
  end
end
