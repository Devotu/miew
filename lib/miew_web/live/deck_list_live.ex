defmodule MiewWeb.DeckListLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <ul class="v-list header">
        <li class="decklist label">
          <span class="v-list-item clickable" phx-click="sort_names" phx-value-order="<%= if @order == :asc do %>asc<% else %>desc<% end %>" >Name</span>
          <span class="v-list-item clickable" phx-click="sort_games" phx-value-order="<%= if @order == :asc do %>asc<% else %>desc<% end %>" >Games</span>
          <span class="v-list-item clickable" phx-click="sort_rank" phx-value-order="<%= if @order == :asc do %>asc<% else %>desc<% end %>" >Rank</span>
        </li>
      </ul>
      <ul class="v-list">
        <%= for deck <- @decks do %>
          <li class="decklist">
            <%= link(deck.name, method: :get, to: "/deck/#{deck.id}", class: "v-list-item")%>
            <span class="v-list-item"><%= Kernel.inspect(Enum.count(deck.results)) %></span>
            <span class="v-list-item"><%= Kernel.inspect(deck.rank) %></span>
          </li>
        <% end %>
      </ul>
    </section>
    <footer>
    </footer>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    decks = Miew.list("deck", sort: "name")
    {:ok, assign(socket, decks: decks, order: :desc)}
  end

  @impl true
  def handle_event("sort_names", params, socket) do
    decks = Miew.list("deck", sort: "name")
    reply_ordered(decks, params["order"], socket)
  end

  @impl true
  def handle_event("sort_games", params, socket) do
    decks = Miew.list("deck", sort: "games")
    reply_ordered(decks, params["order"], socket)
  end

  @impl true
  def handle_event("sort_rank", params, socket) do
    decks = Miew.list("deck", sort: "rank")
    reply_ordered(decks, params["order"], socket)
  end

  defp reply_ordered(decks, "asc", socket) do
    {:noreply, assign(socket, decks: decks, order: :desc)}
  end
  defp reply_ordered(decks, "desc", socket) do
    {:noreply, assign(socket, decks: decks |> Enum.reverse, order: :asc)}
  end
end
