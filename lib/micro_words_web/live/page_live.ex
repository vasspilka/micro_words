defmodule MicroWordsWeb.PageLive do
  use MicroWordsWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, content: "Hello explorer!")}
  end

  def handle_event("explorer", key, socket) do
    IO.inspect(key)
    IO.inspect(socket)
    {:noreply, socket}
  end
end
