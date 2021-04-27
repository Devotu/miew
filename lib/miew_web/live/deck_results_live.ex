defmodule MiewWeb.DeckResultsLive do
  use MiewWeb, :live_view

  defstruct result: nil, z_games: 0, z_winrate: 50, z_power: 0, z_fun: 0, z_wins: 0, opponent: nil

  alias MiewWeb.DeckResultsLive
  alias Miew.Helpers

  @impl true
  def mount(params, _session, socket) do
    deck_id = params["id"]

    deck = Miew.get(deck_id, "deck")

    {tally, tallied_results} = Miew.list(:result, deck.results)
      |> Enum.sort(&(&1.time < &2.time))
      |> Enum.reduce({%DeckResultsLive{}, []}, fn r, acc -> append_sums(r, acc) end)

    {:ok, assign(socket, results: tallied_results, summary: tally)}
  end

  defp append_sums(result, {%DeckResultsLive{} = tally, list}) do
    new_tally = tally
    |> Map.put(:result, result)
    |> increment_games()
    |> sum_power()
    |> sum_fun()
    |> count_wins()
    |> adjust_winrate()
    |> add_opponent()

    {new_tally, list ++ [new_tally]}
  end

  defp increment_games(tally) do
    Map.put tally, :z_games, inc(tally.z_games)
  end

  defp inc(nil), do: 1
  defp inc(x), do: x + 1

  defp count_wins(%{result: %{place: 1}} = tally) do
    Map.put tally, :z_wins, inc(tally.z_wins)
  end
  defp count_wins(tally) do
    tally
  end

  defp adjust_winrate(tally) do
    Map.put tally, :z_winrate, tally.z_wins/tally.z_games |> Float.round(2)
  end

  defp sum_power(tally) do
    Map.put tally, :z_power, add(tally.z_power, tally.result.power)
  end

  defp sum_fun(tally) do
    Map.put tally, :z_fun, add(tally.z_fun, tally.result.fun)
  end

  defp add(nil, nil), do: 0
  defp add(nil, x) when is_number(x), do: x
  defp add(x, nil) when is_number(x), do: x
  defp add(x, y) when is_number(x) and is_number(y), do: x + y

  defp add_opponent(tally) do
    opponent_result = tally.result.game_id
      |> Miew.get("game")
      |> identify_opponent(tally.result.id)
      |> Miew.get("result")

    updated_result = tally.result
      |> Map.put(:opponent, opponent_result.player_id)
      |> Map.put(:opponent_deck, opponent_result.deck_id)

    Map.put tally, :result, updated_result
  end

  defp identify_opponent(game, selected_result_id) do
    game.results
    |> Enum.find(&(&1 != selected_result_id))
  end
end
