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
      player_count: (Miew.list("player") |> Enum.count()),
      deck_count: (Miew.list("deck") |> Enum.count()),
      match_count: (Miew.list("match") |> Enum.count()),
      game_count: (Miew.list("game") |> Enum.count())
    }
    {:ok, assign(socket, params: params)}
  end
end
