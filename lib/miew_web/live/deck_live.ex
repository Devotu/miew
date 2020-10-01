defmodule MiewWeb.DeckLive do
  use MiewWeb, :live_view

  alias Metr
  alias MiewWeb.DeckHelper

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <tr>
          <th>Name</td>
          <th>Format</td>
          <th>Black</td>
          <th>White</td>
          <th>Red</td>
          <th>Green</td>
          <th>Blue</td>
          <th>Colorless</td>
          <th>Rank</td>
          <th>Advantage</td>
        </tr>
        <tr>
          <td><%= @deck.name %></td>
          <td><%= @deck.format %></td>
          <td><%= @deck.black %></td>
          <td><%= @deck.white %></td>
          <td><%= @deck.red %></td>
          <td><%= @deck.green %></td>
          <td><%= @deck.blue %></td>
          <td><%= @deck.colorless %></td>
          <td><%= @deck.rank %></td>
          <td><%= @deck.advantage %></td>
        </tr>
      </table>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    deck = Metr.read_deck(id)
    deck_with_rank = DeckHelper.apply_split_rank(deck)
    {:ok, assign(socket, deck: deck_with_rank)}
  end
end