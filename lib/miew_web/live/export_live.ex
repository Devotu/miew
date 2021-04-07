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
  def handle_event("games", _data, socket) do
    output = Miew.list("result")
      |> convert_games()
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

  defp convert_games(results) when is_list(results) do
    results
    |> Enum.group_by(fn r -> r.game_id end)
    |> Enum.to_list()
    |> Enum.map(&convert_game/1)
    |> Enum.group_by(fn m -> m.combo_key end)
    |> Enum.to_list()
    |> Enum.map(&sum_result/1)
    |> Enum.join(",")
  end

  defp convert_game({_game_id, results}) do
    results
    |> Enum.sort(&(&1.place < &2.place))
    |> Enum.map(fn r -> %{deck_id: r.deck_id, place: r.place} end)
    |> Enum.sort(&(&1.deck_id < &2.deck_id))
    |> merge_set()
  end

  defp merge_set([x, y]) do
    %{combo_key: "#{x.deck_id}-#{y.deck_id}", w1: add_win(x.place), w2: add_win(y.place)}
  end
  defp merge_set(x) do
    {:error, "Invalid merge set input #{Kernel.inspect x} must be [x, y]"}
  end

  defp add_win(0), do: 0
  defp add_win(1), do: 1
  defp add_win(2), do: 0
  defp add_win(_), do: 0

  defp sum_result({combo_key, results}) do
    sums = results
    |> sum_wins()
    |> Tuple.to_list()

    keys = combo_key
    |> split_key()
    |> Tuple.to_list()

    Enum.zip(keys, sums)
    |> build_row()
  end

  defp split_key(key) do
    key
    |> String.split("-")
    |> List.to_tuple()
  end

  defp sum_wins(results) do
    results
    |> Enum.reduce({0,0}, fn %{w1: w1, w2: w2}, {x, y} -> {x + w1, y + w2} end)
  end

  defp build_row([{x_name, x_wins}, {y_name, y_wins}]) do
    "#{x_name}:#{x_wins}-#{y_name}:#{y_wins}"
  end
end
