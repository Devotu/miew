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
      # |> Miew.create_game()
      # |> IO.inspect(label: "apply - result")
    {:noreply, assign(socket, msg: Kernel.inspect(msg))}
  end


  defp parse_input(data) do
    data
    |> split_entries()
    |> divide_attacker_defender()
    |> extract_results()
    |> IO.inspect(label: "parsed")
  end


  defp split_entries(data) do
    data |> String.split(",")
  end

  defp divide_attacker_defender(list) do
    list |> Enum.map(&String.split(&1, "-"))
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
      |> (fn [name, wins] -> %{name: name, wins: wins} end).()
  end

  defp filter_with_games(results) do
    results |> Enum.filter(&has_games?/1)
  end

  defp has_games?(%{attacker: %{wins: "0"}, defender: %{wins: "0"}}), do: false
  defp has_games?(_), do: true


  defp to_atom_game_data(input_data) do
    parts = input_data
      |> build_parts()
    IO.inspect(parts, label: "parts")
    # attack_wins = count_wins input_data, :attacker
    # defend_wins = count_wins input_data, :defender

    # %{
    #   match: nil,
    #   deck_1: attacker.deck_id, deck_2: defender.deck_id,
    #   player_1: attacker.player_id, player_2: defender.player_id,
    #   winner: 0, balance: nil,
    #   power_1: nil, power_2: nil,
    #   fun_1: nil, fun_2: nil,
    #   eval_1: nil, eval_2: nil
    # }
  end


  defp build_parts(input_data) do
    input_data
    |> Enum.filter(&contain_games?/1)
    |> Enum.map(&to_part_tuple/1)
  end


  defp contain_games?(%{attacker: %{wins: "0"}, defender: %{wins: "0"}}), do: false
  defp contain_games?(_non_zero_wins), do: true


  defp to_part_tuple(%{attacker: attacker, defender: defender}) do
    %{attacker: build_part(attacker), defender: build_part(defender)}
  end

  defp build_part(data) do
    deck = get_deck(data)
    %{deck: deck, player: get_player(deck), wins: get_win_count(data.wins)}
  end

  defp get_deck(%{name: deck_name}) do
    deck_name
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
end
