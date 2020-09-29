defmodule MiewWeb.DeckLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <tr>
          <th>Name</td>
          <th>Format</td>
          <th>Rank</td>
          <th>Black</td>
          <th>White</td>
          <th>Red</td>
          <th>Green</td>
          <th>Blue</td>
          <th>Colorless</td>
        </tr>
        <tr>
          <td><%= @deck.name %></td>
          <td><%= @deck.format %></td>
          <td><%= Kernel.inspect(@deck.rank) %></td>
          <td><%= @deck.black %></td>
          <td><%= @deck.white %></td>
          <td><%= @deck.red %></td>
          <td><%= @deck.green %></td>
          <td><%= @deck.blue %></td>
          <td><%= @deck.colorless %></td>
        </tr>
      </table>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    deck = Metr.read_deck(id)
    IO.inspect(deck, label: "deck")
    {:ok, assign(socket, deck: deck)}
  end
end
