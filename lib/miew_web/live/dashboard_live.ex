defmodule MiewWeb.DashboardLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="center-section">
      <ul class="v-list header">
        <li class="dashboardlist label">
          <span class="v-list-item">Players</span>
          <%= link("Decks", method: :get, to: "/deck/list", class: "v-list-item") %>
          <%= link("Matches", method: :get, to: "/match/list", class: "v-list-item") %>
          <span class="v-list-item">Games</span>
        </li>
      </ul>
      <ul class="v-list">
        <li class="dashboardlist">
          <span class="v-list-item"><%= @params.player_count %></span>
          <%= link(@params.deck_count, method: :get, to: "/deck/list", class: "v-list-item") %>
          <%= link(@params.match_count, method: :get, to: "/match/list", class: "v-list-item") %>
          <span class="v-list-item"><%= @params.game_count %></span>
        </li>
      </ul>
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
