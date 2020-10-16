defmodule MiewWeb.MatchListLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <tr>
          <th>Id</td>
          <th>Rank</td>
          <th></td>
        </tr>
        <%= for match <- @matches do %>
          <tr>
            <td><%= match.id %></td>
            <td><%= Kernel.inspect(match.ranking) %></td>
            <td><%= button("->", method: :get, to: "/match/#{match.id}")%></td>
          </tr>
        <% end %>
      </table>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    matches = Miew.list_matches()
    {:ok, assign(socket, matches: matches)}
  end
end
