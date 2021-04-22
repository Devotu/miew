defmodule MiewWeb.DeckRankAdjustLive do
  use MiewWeb, :live_view

  alias Metr
  alias MiewWeb.DeckHelper

  @impl true
  def render(assigns) do
    ~L"""
    <section class="plaque">
      <div>
        <ul class="v-list header">
          <li class="modifyrankrow label">
            <span class="v-list-item">Name</span>
            <span class="v-list-item">Rank</span>
            <span class="v-list-item">Advantage</span>
          </li>
          <li class="modifyrankrow">
            <span class="v-list-item"><%= @deck.name %></span>
            <span class="v-list-item"><%= @deck.rank %></span>
            <span class="v-list-item"><%= @deck.advantage %></span>
          </li>
        </ul>
        <div class="flex flex-spread row append-b">
          <%= if @changes > 0 do %>
          <button class="flexi box-fill" type="button" color="red" phx-click="switch_sure">Do not end</button>
          <% end %>
          <button class="flexi box-fill right" type="button" phx-click="down" phx-value-deck_id=<%= @deck.id %>>-</button>
          <button class="flexi box-fill right" type="button" phx-click="up" phx-value-deck_id=<%= @deck.id %>>+</button>
        </div>
      </div>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    deck = params["id"]
      |> load_deck
    {:ok, assign(socket, deck: deck, changes: 0)}
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


  @impl true
  def handle_event("confirm", _data, socket) do
    case socket.assigns.sure do
      true ->
        {:noreply, assign(socket, sure: !socket.assigns.sure)}
      false ->
        {:noreply, assign(socket, sure: !socket.assigns.sure)}
    end
  end

  def load_deck(id) do
    Miew.get(id, "deck")
    |> DeckHelper.apply_split_rank()
  end
end
