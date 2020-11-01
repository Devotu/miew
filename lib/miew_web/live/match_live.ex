defmodule MiewWeb.MatchLive do
  use MiewWeb, :live_view

  alias Metr
  alias Miew.Helpers

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    match = Miew.read_match(id)
    games = Miew.list_games(match.games)

    {:ok, assign(socket, match: match, games: games, fun1: 0, fun2: 0, winner: 0, sure: false, balance: 0)}
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


  defp create_game(match, input_data) do

    game_data = match
      |> to_atom_game_data()
      |> add_winner(input_data)
      |> add_eval_1(input_data)
      |> add_eval_2(input_data)
      |> add_balance(input_data)

    case Miew.create_game(game_data) do
      {:error, msg} ->
        {:error, msg}
        %{error: "Error", msg: msg}
      game_id ->
        %{id: game_id, balance: "", participants: [
          %{player_id: match.player_one, deck_id: match.deck_one, place: place(1, game_data.winner), fun: game_data.fun_1, power: game_data.power_1},
          %{player_id: match.player_two, deck_id: match.deck_two, place: place(2, game_data.winner), fun: game_data.fun_2, power: game_data.power_2}
        ]}
    end
  end


  defp to_atom_game_data(match) do
    %{
      match: match.id,
      deck_1: match.deck_one, deck_2: match.deck_two,
      player_1: match.player_one, player_2: match.player_two,
      winner: 0, balance: nil,
      power_1: nil, power_2: nil,
      fun_1: nil, fun_2: nil,
      eval_1: nil, eval_2: nil
    }
  end


  defp add_winner(match, input_data) do
    case Integer.parse input_data["winner"] do
      {win_nr, _} ->
        Map.put(match, :winner, win_nr)
      _ ->
        {:error, "invalid winner value"}
    end
  end


  defp add_eval_1(match, input_data) do
    case Helpers.text_to_bool(input_data["eval1"]) do
      true ->
        match
        |> Map.put(:power_1, input_data["pow1"])
        |> Map.put(:fun_1, input_data["fun1"])
      _ ->
        match
    end
  end


  defp add_eval_2(match, input_data) do
    case Helpers.text_to_bool(input_data["eval2"]) do
      true ->
        match
        |> Map.put(:power_2, input_data["pow2"])
        |> Map.put(:fun_2, input_data["fun2"])
      _ ->
        match
    end
  end


  defp add_balance(match, input_data) do
    case Integer.parse input_data["balance"] do
      {balance, _} ->
        Map.put(match, :balance, balance)
      _ ->
        {:error, "invalid balance value"}
    end
  end


  defp place(_participant, 0), do: 0
  defp place(participant, winner) do
    case participant == winner do
      true -> 1
      false -> 2
    end
  end
end
