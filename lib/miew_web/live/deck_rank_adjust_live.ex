defmodule MiewWeb.DeckRankAdjustLive do
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
          <th>Rank</td>
          <th>Advantage</td>
          <th>+</td>
          <th>-</td>
        </tr>
        <tr>
          <td><%= @deck.name %></td>
          <td><%= @deck.rank %></td>
          <td><%= @deck.advantage %></td>
          <td>
            <button phx-click="up" phx-value-deck_id=<%= @deck.id %>>+</button>
          </td>
          <td>
            <button phx-click="down" phx-value-deck_id=<%= @deck.id %>>-</button>
          </td>
        </tr>
      </table>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    deck = Miew.get(id, "deck")
    deck_with_rank = DeckHelper.apply_split_rank(deck)
    {:ok, assign(socket, deck: deck_with_rank)}
  end


  @impl true
  def handle_event("up", data, socket) do
    Miew.bump_rank(data["deck_id"], :up)
    {:noreply, socket}
  end

  @impl true
  def handle_event("down", data, socket) do
    Miew.bump_rank(data["deck_id"], :down)
    {:noreply, socket}
  end
end
