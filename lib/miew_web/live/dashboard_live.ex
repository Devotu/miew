defmodule MiewWeb.DashboardLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <table>
        <tr>
          <th>Players</td>
          <th>Decks</td>
          <th>Matches</td>
          <th>Games</td>
        </tr>
        <tr>
          <td><%= @params.player_count %></td>
          <td><%= @params.deck_count %></td>
          <td><%= @params.match_count %></td>
          <td><%= @params.game_count %></td>
        </tr>
      </table>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    params = %{
      player_count: (Miew.list_players() |> Enum.count()),
      deck_count: (Miew.list_decks() |> Enum.count()),
      match_count: (Miew.list_matches() |> Enum.count()),
      game_count: (Miew.list_games() |> Enum.count())
    }
    {:ok, assign(socket, params: params)}
  end
end
