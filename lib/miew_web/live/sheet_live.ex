defmodule MiewWeb.SheetLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def mount(_params, _session, socket) do
    games = Metr.list_games()
     |> Enum.sort(&(&1.time < &2.time))
    players = Enum.map(Metr.list_players(), fn p -> p.name end)
    decks = Enum.map(Metr.list_decks(), fn d -> d.name end)

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


  defp create_game(%{"p1" => p1, "d1" => d1, "pow1" => pow1, "fun1" => fun1, "p2" => p2, "d2" => d2, "pow2" => pow2, "fun2" => fun2, "winner" => winner} = data) do
    {win_nr, _} = Integer.parse winner

    game_id = Metr.create_game(
      %{
        :deck_1 => d1, :deck_2 => d2,
        :fun_1 => fun1, :fun_2 => fun2,
        :player_1 => p1, :player_2 => p2,
        :power_1 => pow1, :power_2 => pow2,
        :winner => win_nr
      }
    )

    %{id: game_id, participants: [
      %{player_id: p1, deck_id: d1, place: place(1, win_nr), fun: fun1, power: pow1},
      %{player_id: p2, deck_id: d2, place: place(2, win_nr), fun: fun2, power: pow2}
    ]}
  end

  defp place(_participant, 0), do: 0
  defp place(participant, winner) do
    case participant == winner do
      true -> 1
      false -> 2
    end
  end
end
