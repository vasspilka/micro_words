defmodule MicroWordsWeb.PageLive do
  use MicroWordsWeb, :live_view

  alias MicroWords.Explorers
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Location

  # TODO: Generate dynamically from ruleset
  @allowed_actions [
    # actions
    "g",
    "k",
    "p",
    "m",
    # movement
    "w",
    "a",
    "s",
    "d"
  ]

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
  def handle_event("explorer-keypress", %{"key" => key}, socket) when key in @allowed_actions do
    explorer = socket.assigns.explorer
    location_id = socket.assigns.location_id

    :ok = MicroWordsWeb.Endpoint.unsubscribe("location:#{location_id}")

    action_definitions = explorer.ruleset.action_definitions(%{})
    action = Enum.find(action_definitions, &(&1.key_binding == key)).name

    ### Random action for experimentation DO
    data =
      case action do
        :plant_artefact ->
          random_artefact_id = Enum.map(explorer.artefacts, &elem(&1, 1).id) |> Enum.random()

          %{artefact_id: random_artefact_id}

        :forge_note ->
          content = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)

          %{content: content}

        :support_artefact ->
          %{artefact_id: socket.assigns.location.artefact.id}

        :weaken_artefact ->
          %{artefact_id: socket.assigns.location.artefact.id}

        _ ->
          %{}
      end

    ### END

    {:ok, explorer, _} = Explorers.make_action(explorer.id, action, data)

    # TODO: if action not movement we dont need to reassign location
    location_id = Location.id_from_attrs(explorer)
    {:ok, location} = Worlds.get_location(location_id)

    :ok = MicroWordsWeb.Endpoint.subscribe("location:#{location_id}")

    {:noreply,
     assign(socket,
       explorer: explorer,
       location_id: location_id,
       location: location,
       action_definitions: explorer.ruleset.action_definitions(%{})
     )}
  end

  def handle_event("explorer-keypress", %{"key" => _key}, socket) do
    {:noreply, socket}
  end

  @impl true
  def handle_info(%{event: "explorer_affected", payload: explorer}, socket) do
    {:noreply, assign(socket, explorer: explorer)}
  end

  def handle_info(%{event: "location_affected", payload: location}, socket) do
    {:noreply, assign(socket, location: location)}
  end
end
