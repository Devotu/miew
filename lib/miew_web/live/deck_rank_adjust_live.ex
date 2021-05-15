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
          <button class="flexi box-fill" type="button" phx-click="down">-</button>
          <%= if Enum.count(@changes) > 0 do %>
          <button class="flexi box-fill-w confirm" type="button" phx-click="confirm" phx-value-deck_id=<%= @deck.id %>>Confirm</button>
          <% end %>
          <button class="flexi box-fill" type="button" phx-click="up">+</button>
        </div>
      </div>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    deck = params["id"]
      |> load_deck
    {:ok, assign(socket, deck: deck, changes: [])}
  end


  @impl true
  def handle_event("up", _data, socket) do
    assigns = socket.assigns
    {:noreply, assign(socket, deck: assigns.deck, changes: assigns.changes ++ [:up])}
  end

  @impl true
  def handle_event("down", _data, socket) do
    assigns = socket.assigns
    {:noreply, assign(socket, deck: assigns.deck, changes: assigns.changes ++ [:down])}
  end


  @impl true
  def handle_event("confirm", data, socket) do
    id = data["deck_id"]
    socket.assigns.changes
      |> Enum.each(fn dir -> Miew.bump_rank(id, dir) end)
    deck = load_deck(id)
    {:noreply, assign(socket, deck: deck, changes: [])}
  end

  def load_deck(id) do
    Miew.get(id, :deck)
    |> DeckHelper.apply_split_rank()
  end
end
