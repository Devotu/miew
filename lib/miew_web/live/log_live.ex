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
    log = Metr.read_entity_log(type, id)
    {:ok, assign(socket, events: log)}
  end
end
