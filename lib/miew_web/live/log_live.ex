defmodule MiewWeb.LogLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <%= for event <- @events do %>
        <tr>
          <td><%= Kernel.inspect(event) %></td>
        </tr>
        <% end %>
      </table>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    type = params["type"] |> Metr.type_from_string()
    id = params["id"]
    player_log = Metr.read_entity_log(type, id)
    {:ok, assign(socket, events: player_log)}
  end


  @impl true
  @spec handle_event(<<_::24>>, map, any) :: {:noreply, any}
  def handle_event("add", %{"name" => name}, socket) do
    player_id = Miew.create_player(%{name: name})
    {:noreply, assign(socket, name_added: "Added: " <> name)}
  end
end
