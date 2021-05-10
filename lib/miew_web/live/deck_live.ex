defmodule MiewWeb.DeckLive do
  use MiewWeb, :live_view

  alias Metr
  alias MiewWeb.DeckHelper

  @impl true
  def render(assigns) do
    ~L"""
    <section class="plaque">
      <h1 class="header"><%= @deck.name %> (<%= @deck.rank %>)</h1>

      <p class="label v-space">Colors:
      <%= if @deck.black do %><span class="dot black">B</span><% end %>
      <%= if @deck.white do %><span class="dot white">W</span><% end %>
      <%= if @deck.red do %><span class="dot red">R</span><% end %>
      <%= if @deck.green do %><span class="dot green">G</span><% end %>
      <%= if @deck.blue do %><span class="dot blue">B</span><% end %>
      <%= if @deck.colorless do %><span class="dot colorless">X</span><% end %></p>

      <p class="label v-space">Rank:<span class="value"><%= @deck.rank %> / <%= @deck.advantage %></span></p>
      <p class="label v-space">Format:<span class="value"><%= @deck.format %></span></p>
      <p class="label v-space">Price:<span class="value"><%= @deck.price %></span></p>
      <p class="label v-space">Last vs:<span class="value"><%= @last_play.name %></span></p>

    </section>
    <section class="footer">
      <ul class="h-list">
        <li><%= link("Results", method: :get, to: "/deck/#{@deck.id}/results")%></li>
        <li><%= link("Rank", method: :get, to: "/deck/#{@deck.id}/rank")%></li>
        <li><%= link("State", method: :get, to: "/deck/#{@deck.id}/state")%></li>
        <li><%= link("Log", method: :get, to: "/deck/#{@deck.id}/log")%></li>
      </ul>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    deck = Miew.get(id, :deck)
    deck_with_rank = DeckHelper.apply_split_rank(deck)

    last_play = find_last_play(deck.results)

    {:ok, assign(socket, deck: deck_with_rank, last_play: last_play)}
  end


  defp find_last_play([]), do: %{name: "No games registered"}
  defp find_last_play(results) do
    last_result_id = results
      |> List.last()

    last_result_id
    |> Miew.get(:result)
    |> (fn r -> r.game_id end).()
    |> Miew.get(:game)
    |> (fn g -> g.results end).()
    |> Enum.filter(fn r_id -> r_id != last_result_id end)
    |> List.first()
    |> Miew.get(:result)
    |> (fn r -> r.deck_id end).()
    |> Miew.get(:deck)
  end
end
