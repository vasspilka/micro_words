defmodule MicroWordsWeb.PageLive do
  use MicroWordsWeb, :live_view

  alias MicroWords.Explorers
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Location
  @allowed_actions ["w", "a", "s", "d", "ArrowUp", "ArrowLeft", "ArrowRight", "ArrowDown"]

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
    {action_type, action_data} = action(key)

    explorer = socket.assigns.explorer

    case action_type do
      :move ->
        Explorers.move(explorer.id, action_data.direction)

      _ ->
        nil
    end

    # {:ok, assign(socket, location_id: location_id, location: location)}
    {:noreply, socket}
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
        {:move, %{directrion: :south}}

      key when key in ["a", "ArrowLeft"] ->
        {:move, %{directrion: :west}}

      key when key in ["p"] ->
        {:action, %{name: :plant_artefact}}
    end
  end
end
