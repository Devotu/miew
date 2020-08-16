defmodule MiewWeb.DeckGamesLive do
  use MiewWeb, :live_view

  defstruct vs_deck: nil, vs_player: nil, power: nil, fun: nil, z_winrate: 50, z_power: 0, z_fun: 0

  alias MiewWeb.DeckGamesLive

  @impl true
  def mount(params, _session, socket) do
    deck_id = params["id"]

    games = Metr.list_games(:deck, deck_id)
      |> Enum.sort(&(&1.time < &2.time))
      |> Enum.map(fn g -> {find_selected(g.participants, deck_id), find_opponent(g.participants, deck_id)} end)
      |> Enum.reduce(
        %{games: [], game_count: 0, win_count: 0, winrate: 0, z_power: 0, powerrate: 0, z_fun: 0, funrate: 0},
        fn so, acc -> calculate_rates(so, acc) end
        )
      |> Map.get(:games)

    {:ok, assign(socket, games: games)}
  end


  defp inc_win(current, 1), do: inc(current)
  defp inc_win(current, _place), do: current

  defp inc(count), do: count + 1


  defp calc_rate(value, games) do
    value/games
    |> Float.round(1)
  end

  defp calc_rate_pc(value, games) do
    value/games * 100
    |> Float.round(1)
  end


  defp calculate_rates(
    {selected, _opponent} = so,
    %{games: _games, game_count: _gc, win_count: _wc, winrate: _wr, z_power: _p, powerrate: _pr, z_fun: _f, funrate: _fr} = acc)
  do
    acc
    |> inc_games()
    |> add_win(selected)
    |> add_power(selected)
    |> add_fun(selected)
    |> calc_winrate()
    |> calc_powerrate()
    |> calc_funrate()
    |> convert_to_game(so)
  end


  defp inc_games(%{game_count: _gc} = acc) do
    Map.update!(acc, :game_count, &inc/1)
  end

  defp add_win(%{win_count: _wc} = acc, selected) do
    Map.update!(acc, :win_count, fn wc -> inc_win(wc, selected.place) end)
  end

  defp add_power(%{z_power: _p} = acc, selected) do
    {power_increase, ""} = Integer.parse(selected.power)
    Map.update!(acc, :z_power, fn p -> p + power_increase end)
  end

  defp add_fun(%{z_fun: _p} = acc, selected) do
    {fun_increase, ""} = Integer.parse(selected.fun)
    Map.update!(acc, :z_fun, fn f -> f + fun_increase end)
  end


  defp calc_winrate(%{game_count: gc, win_count: wc} = acc) do
    Map.update!(acc, :winrate, fn _wr -> calc_rate_pc(wc, gc) end)
  end

  defp calc_powerrate(%{game_count: gc, z_power: p} = acc) do
    Map.update!(acc, :powerrate, fn _pr -> calc_rate(p, gc) end)
  end

  defp calc_funrate(%{game_count: gc, z_fun: p} = acc) do
    Map.update!(acc, :funrate, fn _fr -> calc_rate(p, gc) end)
  end


  defp convert_to_game(
    %{games: _games, winrate: wr, powerrate: pr, funrate: fr} = acc,
    {selected, opponent}
    )
  do
    game = %DeckGamesLive{
      vs_deck: opponent.deck_id,
      vs_player: opponent.player_id,
      power: selected.power,
      fun: selected.fun,
      z_winrate: wr,
      z_power: pr,
      z_fun: fr
    }

    Map.update!(acc, :games, fn games -> games ++ [game] end)
  end


  defp find_selected(participants, deck_id) do
    participants
    |> Enum.filter(fn p -> p.deck_id == deck_id end)
    |> List.first()
  end

  defp find_opponent(participants, deck_id) do
    participants
    |> Enum.filter(fn p -> p.deck_id != deck_id end)
    |> List.first()
  end
end
