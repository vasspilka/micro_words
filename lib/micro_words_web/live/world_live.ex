defmodule MicroWordsWeb.WorldLive do
  use MicroWordsWeb, :live_view

  alias MicroWords.Explorers
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Location
  @impl true
  def render(assigns) do
    ~H"""
    <h1 class="text-3xl font-bold text-center mb-8">
    You are at: <%= @location_id %>
    </h1>
    <div class="grid grid-cols-9 gap-4 min-h-full">
    <section class="col-span-2 grid grid-cols-1 bg-blue-100 ">
        <div>ID: <%= @explorer.id %></div>
        <div>ENERGY: <%= @explorer.energy %></div>
        <div>XP: <%= @explorer.xp %></div>
        <div class="mt-8 mb-4">Notes: </div>
        <div class="grid grid-flow-row auto-rows-max">
            <%= for {_id, material} <- @explorer.materials do %>
                <div class="grid grid-cols-5 border border-gray-200">
                    <div class="col-span-4"><%= material.content %></div>
                    <div class="col-span-1">
                        <button
                            phx-click="explorer-action"
                            phx-value-action="plant_material"
                            phx-value-data={Jason.encode!(%{material_id: material.id})}
                            class="p-2 shadow bg-teal-400 font-bold rounded text-white" >
                            Place
                        </button>
                    </div>
                </div>
            <% end %>
        </div>
        <div class="mt-10 ">
            <form phx-submit="explorer-action">
                <div class="flex flex-wrap mb-3">
                    <div class="object-center">
                        <textarea
                          class="py-2 px-4 border border-gray-200 rounded"
                          id="message"
                          type="text"
                          name="data[content]"
                          placeholder="Note..."/>
                    </div>
                </div>

                <input class="hidden" name="action" type="text" value="forge_note"/>

                <div class="">
                    <button class="shadow bg-teal-400 text-white font-bold py-2 px-4 rounded"
                            type="submit">
                        Create Note
                    </button>
                </div>
            </form>
        </div>
    </section>
    <section class="col-span-7 text-center bg-green-100">
        <p>Content</p>
        <%= if @location.material do %>
            <div class="h-64 min-h-max">
                <%= @location.material.content %>
                <div>Energy: <%=  @location.material.energy %></div>
            </div>
            <button
                class="p-2 shadow bg-teal-400 font-bold rounded text-white"
                phx-click="explorer-action"
                phx-value-action="support_material"
                phx-value-data={Jason.encode!(%{material_id: @location.material.id})} >
                Support
            </button>
            <button
                class="p-2 shadow bg-teal-400 font-bold rounded text-white"
                phx-click="explorer-action"
                phx-value-action="weaken_material"
                phx-value-data={Jason.encode!(%{material_id: @location.material.id})} >
                Discourage
            </button>
        <% else %>
            <div class="h-64 min-h-max"></div>
        <% end %>
        <p>Location</p>
        <div>Energy: <%= @location.ground.energy %></div>

        <div class="flex flex-row">
            <div class="grid grid-cols-3 grid-rows-2 gap-1 float-right">
                <div></div>
                <button
                    class="p-2 shadow bg-teal-400 font-bold rounded"
                    phx-click="explorer-action"
                    phx-value-action="move_north">
                    <div class="h-5 w-5 border-l-4 border-t-4 border-white transform rotate-45"/>
                </button>
                <div></div>
                <button
                    class="p-2 shadow bg-teal-400 font-bold rounded"
                    phx-click="explorer-action"
                    phx-value-action="move_west">
                        <div class="h-5 w-5 border-b-4 border-l-4 border-white transform rotate-45"/>
                </button>
                <button
                    class="p-2 shadow bg-teal-400 font-bold rounded"
                    phx-click="explorer-action"
                    phx-value-action="move_south">
                        <div class="h-5 w-5 border-r-4 border-b-4 border-white transform rotate-45"/>
                </button>
                <button
                    class="p-2 shadow bg-teal-400 font-bold rounded"
                    phx-click="explorer-action"
                    phx-value-action="move_east">
                        <div class="h-5 w-5 border-t-4 border-r-4 border-white transform rotate-45"/>
                </button>
            </div>
        </div>

    </section>
    </div>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok, explorer} = MicroWords.Explorers.enter_world(params["username"], params["world"])

    location_id = Location.id_from_attrs(explorer)
    {:ok, location} = Worlds.get_location(location_id)

    :ok = MicroWordsWeb.Endpoint.subscribe("explorer:#{explorer.id}")
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
  def handle_event("explorer-action", %{"action" => action, "data" => data} = some, socket)
      when is_binary(action) do
    action_name = String.to_existing_atom(action)

    data =
      case data do
        %{} -> data
        _ -> Jason.decode!(data)
      end

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
    handle_event("explorer-action", %{"action" => action, "data" => "{}"}, socket)
  end

  @impl true
  def handle_info(%{event: "explorer_affected", payload: explorer}, socket) do
    {:noreply, assign(socket, explorer: explorer)}
  end

  def handle_info(%{event: "location_affected", payload: location}, socket) do
    {:noreply, assign(socket, location: location)}
  end
end
