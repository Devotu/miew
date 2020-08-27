defmodule MiewWeb.SheetLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def mount(_params, _session, socket) do
    games = Metr.list_games()
     |> Enum.sort(&(&1.time < &2.time))
    players = Enum.map(Metr.list_players(), fn p -> p.id end)
    decks = Enum.map(Metr.list_decks(), fn d -> d.id end)

    {:ok, assign(socket, games: games, p1: "", d1: "", pow1: 0, fun1: 0, pl1: 0, p2: "", d2: "", pow2: 0, fun2: 0, pl2: 0, winner: 0, players: players, decks: decks)}
  end


  @impl true
  def handle_event("add", %{"winner" => _winner} = data, socket) do
    game = create_game(data)
    {:noreply, assign(socket, games: socket.assigns.games ++ [game])}
  end

  @impl true
  def handle_event("add", %{} = data, socket) do
    data_with_winner = Map.put(data, "winner", "0")
    game =  create_game(data_with_winner)
    {:noreply, assign(socket, games: socket.assigns.games ++ [game])}
  end

  @impl true
  def handle_event("delete_game", %{"game_id" => game_id}, socket) do
    Metr.delete_game(game_id)
    games = Metr.list_games()
     |> Enum.sort(&(&1.time < &2.time))
    {:noreply, assign(socket, games: games)}
  end


  defp create_game(%{"p1" => p1, "d1" => d1, "p2" => p2, "d2" => d2, "winner" => winner} = data) do
    {win_nr, _} = Integer.parse winner

    d = data
      |> Map.put_new("eval1", nil)
      |> add_eval_1()
      |> Map.put_new("eval2", nil)
      |> add_eval_2()

    metr_game = %{
      :deck_1 => d["d1"], :deck_2 => d["d2"],
      :player_1 => d["p1"], :player_2 => d["p2"],
      :winner => win_nr,
      :power_1 => d.power_1, :power_2 => d.power_2,
      :fun_1 => d.fun_1, :fun_2 => d.fun_2
    }

    game_id = Metr.create_game(metr_game)

    %{id: game_id, participants: [
      %{player_id: p1, deck_id: d1, place: place(1, win_nr), fun: d.fun_1, power: d.power_1},
      %{player_id: p2, deck_id: d2, place: place(2, win_nr), fun: d.fun_2, power: d.power_2}
    ]}
  end

  defp add_eval_1(%{"eval1" => nil} = data) do
    data
      |> Map.put(:power_1, nil)
      |> Map.put(:fun_1, nil)
  end
  defp add_eval_1(%{"eval1" => "true"} = data) do
    data
      |> Map.put(:power_1, data["pow1"])
      |> Map.put(:fun_1, data["fun1"])
  end

  defp add_eval_2(%{"eval2" => nil} = data) do
    data
      |> Map.put(:power_2, nil)
      |> Map.put(:fun_2, nil)
  end
  defp add_eval_2(%{"eval2" => "true"} = data) do
    data
      |> Map.put(:power_2, data["pow2"])
      |> Map.put(:fun_2, data["fun2"])
  end


  defp place(_participant, 0), do: 0
  defp place(participant, winner) do
    case participant == winner do
      true -> 1
      false -> 2
    end
  end
end
