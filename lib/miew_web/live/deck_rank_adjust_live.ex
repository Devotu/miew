defmodule MiewWeb.DeckRankAdjustLive do
  use MiewWeb, :live_view

  alias Metr
  alias MiewWeb.DeckHelper

  @impl true
  def render(assigns) do
    ~L"""
    <section>
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
    deck = params["id"]
      |> load_deck
    {:ok, assign(socket, deck: deck)}
  end


  @impl true
  def handle_event("up", data, socket) do
    id = data["deck_id"]
    Miew.bump_rank(id, :up)
    deck = load_deck(id)
    {:noreply, assign(socket, deck: deck)}
  end

  @impl true
  def handle_event("down", data, socket) do
    id = data["deck_id"]
    Miew.bump_rank(id, :down)
    deck = load_deck(id)
    {:noreply, assign(socket, deck: deck)}
  end

  def load_deck(id) do
    Miew.get(id, "deck")
    |> DeckHelper.apply_split_rank()
  end
end
