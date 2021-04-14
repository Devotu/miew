defmodule MiewWeb.MatchListLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <table>
        <tr>
          <th>Id</td>
          <th>Status</td>
          <th>Rank</td>
          <th>Player 1</td>
          <th>Player 2</td>
          <th>Games</td>
          <th></td>
        </tr>
        <%= for match <- @matches do %>
          <tr>
            <td><%= match.id %></td>
            <td><%= Kernel.inspect(match.status) %></td>
            <td><%= Kernel.inspect(match.ranking) %></td>
            <td><%= match.player_one %>/<%= match.deck_one %></td>
            <td><%= match.player_two %>/<%= match.deck_two %></td>
            <td><%= Kernel.inspect(Enum.count(match.games)) %></td>
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
