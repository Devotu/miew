defmodule MiewWeb.DeckListLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <ul class="v-list">
        <li class="decklist header">
          <span class="v-list-item">Name</span>
          <span class="v-list-item">Games</span>
          <span class="v-list-item">Rank</span>
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
    {:ok, assign(socket, decks: decks)}
  end
end
