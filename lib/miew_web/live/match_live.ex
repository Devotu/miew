defmodule MiewWeb.MatchLive do
  use MiewWeb, :live_view

  alias Metr
  alias Miew.Helpers

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    match = Miew.read_match(id)
    games = Miew.list_games(match.games)

    {:ok, assign(socket, match: match, games: games, pow1: 0, fun1: 0, pow2: 0, fun2: 0, winner: 0, sure: false)}
  end


  @impl true
  def handle_event("add", %{"winner" => _winner} = data, socket) do
    game = create_game(socket.assigns.match, data)
    {:noreply, assign(socket, games: socket.assigns.games ++ [game])}
  end

  @impl true
  def handle_event("add", %{} = data, socket) do
    data_with_winner = Map.put(data, "winner", "0")
    game =  create_game(socket.assigns.match, data_with_winner)
    {:noreply, assign(socket, games: socket.assigns.games ++ [game])}
  end


  @impl true
  def handle_event("switch_sure", _data, socket) do
    case socket.assigns.sure do
      true ->
        {:noreply, assign(socket, sure: !socket.assigns.sure)}
      false ->
        {:noreply, assign(socket, sure: !socket.assigns.sure)}
    end
  end


  @impl true
  def handle_event("end", _data, socket) do
    case Miew.end_match(socket.assigns.match.id) do
      :ok ->
        match = Miew.read_match(socket.assigns.match.id)
        {:noreply, assign(socket, match: match)}
      {:error, msg} ->
        {:noreply, put_flash(socket, :end_feedback, msg)}
      _ ->
        {:noreply, put_flash(socket, :end_feedback, "Unknown error")}
    end
  end


  defp create_game(match, %{"winner" => winner} = data) do
    {win_nr, _} = Integer.parse winner

    d = data
      |> Map.put_new("eval1", nil)
      |> add_eval_1()
      |> Map.put_new("eval2", nil)
      |> add_eval_2()

    metr_game = %{
      :match => match.id,
      :deck_1 => match.deck_one, :deck_2 => match.deck_two,
      :player_1 => match.player_one, :player_2 => match.player_two,
      :winner => win_nr,
      :power_1 => d.power_1, :power_2 => d.power_2,
      :fun_1 => d.fun_1, :fun_2 => d.fun_2
    }

    case Metr.create_game(metr_game) do
      {:error, msg} ->
        {:error, msg}
        %{id: "Error - #{msg}",
        match: match,
        data: data}
      game_id ->
        %{id: game_id, participants: [
          %{player_id: match.player_one, deck_id: match.deck_one, place: place(1, win_nr), fun: d.fun_1, power: d.power_1},
          %{player_id: match.player_two, deck_id: match.deck_two, place: place(2, win_nr), fun: d.fun_2, power: d.power_2}
        ]}
    end
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
