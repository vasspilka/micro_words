defmodule MicroWordsWeb.HomePageLive do
  use MicroWordsWeb, :live_view

  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-center text-2xl">Welcome to MicroWords</h1>

    <h1 class="text-center text-xl mt-2">Select a world</h1>
    <div class="flex flex-row justify-center">
        <%= for {world, _} <- Application.get_env(:micro_words, :worlds) do %>
        <% color = if assigns.world == world, do: "bg-yellow-400", else: "bg-indigo-400 text-white" %>
            <button
            class={"m-1 p-2 font-bold rounded " <> color}
            phx-click="select-world"
            phx-value-world={world}>
                <%= world %>
            </button>
        <% end %>
    </div>

    <form class="grid grid-cols-1 justify-items-center mt-5" phx-submit="enter-world" phx-change="update-explorer">
      <label for="exlorer">Join as</label>
      <input
        phx-debounce="2000"
        class="bg-gray-100 w-28 h-8"
        name="explorer"
        type="text"
        placeholder="username"
        value={assigns.explorer}
        />
      <button
        class="p-3 text-white bg-indigo-400 font-bold w-26 mt-3"
        type="submit">
        Enter
      </button>
    </form>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, world: nil, explorer: "")}
  end

  @impl true
  def handle_event("select-world", %{"world" => world}, socket) do
    {:noreply, assign(socket, world: world)}
  end

  @impl true
  def handle_event("update-explorer", %{"explorer" => explorer}, socket) do
    {:noreply, assign(socket, explorer: explorer)}
  end

  @impl true
  def handle_event("enter-world", %{"explorer" => explorer}, socket) do
    socket =
      if socket.assigns.world && explorer != "" do
        push_redirect(socket, to: "/#{socket.assigns.world}?username=#{explorer}")
      else
        socket
      end

    {:noreply, socket}
  end
end
