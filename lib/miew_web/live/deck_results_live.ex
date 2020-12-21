defmodule MiewWeb.DeckResultsLive do
  use MiewWeb, :live_view

  defstruct result: nil, z_games: 0, z_winrate: 50, z_power: 0, z_fun: 0

  alias MiewWeb.DeckResultsLive

  @impl true
  def mount(params, _session, socket) do
    deck_id = params["id"]

    deck = Miew.get(deck_id, "deck")

    {tally, tallied_results} = Miew.list(:result, deck.results)
      |> Enum.sort(&(&1.time < &2.time))
      |> Enum.reduce({%DeckResultsLive{}, []}, fn r, acc -> append_sums(r, acc) end)

    {:ok, assign(socket, results: tallied_results)}
  end

  defp append_sums(result, {%DeckResultsLive{} = tally, list}) do
    new_tally = tally
    |> Map.put(:result, result)
    |> increment_games()
    |> sum_power()
    |> sum_fun()

    {new_tally, list ++ [new_tally]}
  end

  defp increment_games(tally) do
    Map.put tally, :z_games, inc(tally.z_games)
  end

  defp inc(nil), do: 1
  defp inc(x), do: x + 1


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
end
