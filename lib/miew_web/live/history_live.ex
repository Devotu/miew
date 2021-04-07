defmodule MiewWeb.HistoryLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <tr>
          <th>#(<%= @count %>)</th>
          <th>Event</th>
          <th>Data</th>
          <th>State</th>
        </tr>
        <%= for event <- @history do %>
        <tr>
          <td width="5%"><%= Kernel.inspect(event.nr) %></td>
          <td width="30%"><%= Kernel.inspect(event.event) %></td>
          <td width="30%"><%= Kernel.inspect(event.data) %></td>
          <td width="30%"><%= Kernel.inspect(event.state) %></td>
        </tr>
        <% end %>
      </table>
    </section>
    """
  end

  @impl true
  def mount(%{"id" => id, "type" => type_input}, _session, socket) do
    {history, count} = Miew.read_entity_history(id, type_input)
      |> IO.inspect(label: "history")
      |> Enum.reduce({[], 1}, fn l, {acc, at} -> {acc ++ [Map.put(l, :nr, at)], at + 1} end)
    {:ok, assign(socket, history: history, count: count)}
  end
end
