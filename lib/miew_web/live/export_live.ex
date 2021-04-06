defmodule MiewWeb.ExportLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <table>
        <tr>
          <td>
            <button phx-click="decks">Decks</button>
          </td>
          <td>
            <button phx-click="games">Games</button>
          </td>
        </tr>
      </table>
    </section>
    <section class="phx-hero">
      <table>
        <tr>
          <th>Output</td>
        </tr>
        <tr>
          <td>
            <p><%= @output %>
          </td>
        </tr>
      </table>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, output: "Output as text")}
  end

  @impl true
  def handle_event("decks", _data, socket) do
    output = Miew.list("deck")
      |> convert_decks()
    {:noreply, assign(socket, output: output)}
  end

  defp convert_decks(decks) when is_list(decks) do
    players = Miew.list("player")
    decks
    |> Enum.map(fn d -> merge_owner(d, players) end)
    |> Enum.map(&convert_deck/1)
  end

  defp convert_deck(d) when is_map(d) do
    """
    #{d.price};#{d.format};#{d.name};#{d.player_id};#{d.theme};#{bn(d.red)};#{bn(d.green)};#{bn(d.white)};#{bn(d.black)};#{bn(d.blue)},
    """
    |> String.trim()
  end

  defp bn(true), do: 1
  defp bn(false), do: 0

  defp merge_owner(deck, players) do
    owner = Enum.find(players, nil, fn p -> Enum.member?(p.decks, deck.id) end)
    Map.put(deck, :player_id, owner.id)
  end
end
