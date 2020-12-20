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

    location_id = Location.id_from_attrs(explorer)
    {:ok, location} = Worlds.get_location(location_id)

    {:ok, assign(socket, explorer: explorer, location_id: location_id, location: location)}
  end

  @impl true
  def handle_event("explorer-keypress", %{"key" => key}, socket) when key in @allowed_actions do
    explorer = socket.assigns.explorer

    {:ok, explorer} =
      case action(key) do
        {:move, %{direction: direction}} ->
          Explorers.move(explorer.id, direction)

        {:action, %{name: action, data: data}} ->
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

    {:noreply, assign(socket, explorer: explorer, location_id: location_id, location: location)}
  end

  def handle_event("explorer-keypress", %{"key" => _key}, socket) do
    {:noreply, socket}
  end

  @spec action(binary()) :: {atom(), map()}
  defp action(key) do
    case key do
      key when key in ["w", "ArrowUp"] ->
        {:move, %{direction: :north}}

      key when key in ["d", "ArrowRight"] ->
        {:move, %{direction: :east}}

      key when key in ["s", "ArrowDown"] ->
        {:move, %{direction: :south}}

      key when key in ["a", "ArrowLeft"] ->
        {:move, %{direction: :west}}

      key when key in ["m"] ->
        content = :crypto.strong_rand_bytes(16) |> Base.url_encode64() |> binary_part(0, 16)

        {:action,
         %{
           name: :forge_artefact,
           data: %{content: content}
         }}

      key when key in ["p"] ->
        {:action, %{name: :plant_artefact, data: %{}}}
    end
  end
end
