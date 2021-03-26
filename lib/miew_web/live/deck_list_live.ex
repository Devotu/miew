defmodule MiewWeb.DeckListLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <tr>
          <th>Name</td>
          <th>Id</td>
          <th>Rank</td>
          <th></td>
        </tr>
        <%= for deck <- @decks do %>
          <tr>
            <td><%= deck.name %></td>
            <td><%= deck.id %></td>
            <td><%= Kernel.inspect(deck.rank) %></td>
            <td><%= button("->", method: :get, to: "/deck/#{deck.id}")%></td>
          </tr>
        <% end %>
      </table>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    decks = Metr.list_decks()
      |> Enum.sort(fn a, b -> a.name < b.name end)
    {:ok, assign(socket, decks: decks)}
  end
end
