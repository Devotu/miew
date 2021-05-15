defmodule Miew.Helpers.GameHelpers do

  alias Metr.Modules.Input.GameInput

  def to_game_input(%{deck_1: d1, deck_2: d2, player_1: p1, player_2: p2, winner: w} = data) do
    %GameInput{
      player_one: p1,
      player_two: p2,
      deck_one: d1,
      deck_two: d2,
      winner: w,
    }
    |> add_match(data)
    |> add_turns(data)
    |> add_power(data)
    |> add_fun_one(data)
    |> add_fun_two(data)
  end

  defp add_match(%GameInput{} = gi, %{match: match}), do: Map.put gi, :match, match
  defp add_match(gi, _), do: gi

  defp add_turns(%GameInput{} = gi, %{turns: turns}), do: Map.put gi, :turns, turns
  defp add_turns(gi, _), do: gi

  defp add_fun_one(%GameInput{} = gi, %{fun_1: f1}), do: Map.put gi, :fun_one, f1
  defp add_fun_one(gi, _), do: gi

  defp add_fun_two(%GameInput{} = gi, %{fun_2: f2}), do: Map.put gi, :fun_two, f2
  defp add_fun_two(gi, _), do: gi

  defp add_power(%GameInput{} = gi, %{balance: balance}) do
    {p1, p2} = balance
    |> parse_balance()

    gi
    |> Map.put(:power_one, p1)
    |> Map.put(:power_two, p2)
  end
  defp add_power(gi, _), do: gi


  defp parse_balance({0, 0}), do: {0, 0}
  defp parse_balance({1, 1}), do: {1, -1}
  defp parse_balance({1, 2}), do: {2, -2}
  defp parse_balance({2, 1}), do: {-1, 1}
  defp parse_balance({2, 2}), do: {-2, 2}
  defp parse_balance(nil), do: {nil, nil}
  defp parse_balance(_), do: {:error, "invalid input balance"}
end
