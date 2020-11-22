defmodule MicroWordsWeb.PageLive do
  use MicroWordsWeb, :live_view

  @allowed_actions ["w", "a", "s", "d", "ArrowUp", "ArrowLeft", "ArrowRight", "ArrowDown"]

  @impl true
  def mount(params, session, socket) do
    world = socket.private.connect_params["world"]
    explorer_id = socket.private.connect_params["explorer_uuid"]

    # Get or create exlorer.
    {:ok, assign(socket, content: "Hello explorer!")}
  end

  def handle_event("explorer-action", %{"key" => key}, socket) when key in @allowed_actions do
    {action_type, action_data} = action(key)

    case action_type do
      "Move" ->
        Enum
        nil

      _ ->
        nil
    end

    {:noreply, socket}
  end

  @spec action(binary()) :: {binary(), map()}
  defp action(key) do
    case key do
      key when key in ["w", "ArrowUp"] ->
        {"Move", %{direction: "North"}}

      key when key in ["d", "ArrowRight"] ->
        {"Move", %{direction: "East"}}

      key when key in ["s", "ArrowDown"] ->
        {"Move", %{directrion: "South"}}

      key when key in ["a", "ArrowLeft"] ->
        {"Move", %{directrion: "West"}}
    end
  end
end
