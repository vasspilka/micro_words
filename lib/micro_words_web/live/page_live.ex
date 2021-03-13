defmodule MicroWordsWeb.PageLive do
  use MicroWordsWeb, :live_view

  alias MicroWords.Explorers
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Location

  @allowed_actions [
    # actions
    "p",
    "m",
    # movement
    "w",
    "a",
    "s",
    "d",
    "ArrowUp",
    "ArrowLeft",
    "ArrowRight",
    "ArrowDown"
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
       location: location
     )}
  end

  @impl true
  def handle_event("explorer-keypress", %{"key" => key}, socket) when key in @allowed_actions do
    explorer = socket.assigns.explorer
    location_id = socket.assigns.location_id

    :ok = MicroWordsWeb.Endpoint.unsubscribe("location:#{location_id}")

    {:ok, explorer} =
      case action(key) do
        %{name: action, data: data} ->
          ### Random action experimentation
          data =
            case action do
              :plant_artefact ->
                random_artefact_id =
                  Enum.map(explorer.artefacts, &elem(&1, 1).id) |> Enum.random()

                %{artefact_id: random_artefact_id}

              _ ->
                data
            end

          ### END

          {:ok, explorer, _} = Explorers.make_action(explorer.id, action, data)
          {:ok, explorer}
      end

    location_id = Location.id_from_attrs(explorer)
    {:ok, location} = Worlds.get_location(location_id)

    :ok = MicroWordsWeb.Endpoint.subscribe("location:#{location_id}")

    {:noreply, assign(socket, explorer: explorer, location_id: location_id, location: location)}
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

  @spec action(binary()) :: %{name: :atom, data: map()}
  defp action(key) do
    case key do
      key when key in ["w", "ArrowUp"] ->
        %{name: :move_north, data: %{}}

      key when key in ["d", "ArrowRight"] ->
        %{name: :move_east, data: %{}}

      key when key in ["s", "ArrowDown"] ->
        %{name: :move_south, data: %{}}

      key when key in ["a", "ArrowLeft"] ->
        %{name: :move_west, data: %{}}

      key when key in ["m"] ->
        content = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)

        %{name: :forge_note, data: %{content: content}}

      key when key in ["p"] ->
        %{name: :plant_artefact, data: %{}}
    end
  end
end
