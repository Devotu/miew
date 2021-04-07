defmodule MiewWeb.ParseGamesLive do
  use MiewWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, parsed: [], results: [], input_data: "", msg: "")}
  end


  @impl true
  def handle_event("parse", %{"data" => data}, socket) do
    parsed = parse_input(data)

    results = parsed
      |> filter_with_games()

    {:noreply, assign(socket, parsed: parsed, results: results, input_data: data)}
  end


  @impl true
  def handle_event("apply", %{"input_data" => data}, socket) do
    msg = data
      |> String.replace("\"", "")
      |> parse_input()
      |> to_atom_game_data()
      |> Enum.map(&Miew.create_game/1)
    {:noreply, assign(socket, msg: Kernel.inspect(msg))}
  end


  defp parse_input(data) do
    data
    |> split_entries()
    |> divide_attacker_defender()
    |> extract_results()
  end


  defp split_entries(data) do
    data |> String.split(",")
  end

  defp divide_attacker_defender(list) do
    list
    |> Enum.map(&String.split(&1, "-"))
  end

  defp extract_results(results) do
    results |> Enum.map(&extract_result/1)
  end

  defp extract_result([attacker, defender]) do
    %{attacker: split_result(attacker), defender: split_result(defender)}
  end

  defp split_result(result) do
    result
      |> String.split(":")
      |> Enum.map(&String.trim/1)
      |> (fn [name, wins] -> %{name: name, wins: wins} end).()
  end

  defp filter_with_games(results) do
    results |> Enum.filter(&has_games?/1)
  end

  defp has_games?(%{attacker: %{wins: "0"}, defender: %{wins: "0"}}), do: false
  defp has_games?(_), do: true


  defp to_atom_game_data(input_data) do
    input_data
    |> Enum.filter(&contain_games?/1)
    |> build_full_rows()
    |> Enum.map(&row_game_data_list/1)
    |> Enum.concat()
  end


  defp build_full_rows(input_data) do
    input_data
    |> Enum.map(&fill_row_map/1)
  end


  defp contain_games?(%{attacker: %{wins: "0"}, defender: %{wins: "0"}}), do: false
  defp contain_games?(_non_zero_wins), do: true


  defp fill_row_map(%{attacker: attacker, defender: defender}) do
    %{attacker: build_part(attacker), defender: build_part(defender)}
  end

  defp build_part(data) do
    deck = get_deck(data)
    %{deck: deck, player: get_player(deck), wins: get_win_count(data.wins)}
  end

  defp get_deck(%{name: deck_name}) do
    deck_name
    |> String.trim()
    |> Metr.Id.hrid()
    |> Miew.get("Deck")
  end

  defp get_player(%{id: deck_id}) do
    Miew.list("Player")
    |> Enum.find({:error, "No owner found"}, fn p -> Enum.any?(p.decks, fn did -> did == deck_id end) end)
  end

  defp get_win_count(wins) do
    {count, _} = Integer.parse(wins)
    count
  end

  defp row_game_data_list(row) do
    attacker_wins = fill_wins(row.attacker, row.attacker, row.defender)
    defender_wins = fill_wins(row.defender, row.defender, row.attacker)
    attacker_wins ++ defender_wins
  end

  defp fill_wins(%{wins: 0}, _winner, _looser), do: []
  defp fill_wins(%{wins: wins}, winner, looser) do
    Enum.map(0..wins - 1, fn _w -> new_game_data(winner, looser) end)
  end

  defp new_game_data(winner, looser) do
    %{
      match: nil,
      deck_1: winner.deck.id, deck_2: looser.deck.id,
      player_1: winner.player.id, player_2: looser.player.id,
      winner: 1, balance: nil,
      power_1: nil, power_2: nil,
      fun_1: nil, fun_2: nil,
      eval_1: nil, eval_2: nil
    }
  end
end
