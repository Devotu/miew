defmodule MiewWeb.LogLive do
  use MiewWeb, :live_view

  alias Metr
  alias Miew.Helpers

  @impl true
  def render(assigns) do
    ~L"""
    <%= for event <- @events do %>
    <section class="plaque v-fill">
      <pre><%= Helpers.to_pretty(event) %></pre>
    </section>
    <% end %>
    """
  end

  @impl true
  def mount(%{"id" => id, "type" => type_input}, _session, socket) do
    type = Miew.type_from_string(type_input)
    log = Metr.read_entity_log(type, id)
    {:ok, assign(socket, events: log)}
  end

  def mount(%{"limit" => limit_input}, _session, socket) do
    {limit, ""} = Integer.parse(limit_input)
    {:ok, assign(socket, events: Metr.read_global_log(limit))}
  end
end
