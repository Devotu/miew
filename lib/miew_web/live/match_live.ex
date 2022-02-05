defmodule MiewWeb.MatchLive do
  use MiewWeb, :live_view

  alias Miew.Helpers

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    match = Miew.get(id, :match)
    results = match.games
      |> Miew.list_games()
      |> Enum.map(fn g -> %{id: g.id, turns: g.turns, results: Miew.list_results(g.results), time: g.time} end)
      |> Enum.sort(fn r1, r2 -> r1.time < r2.time end)
    tags = Miew.list_game_conclusion_tags()

    {:ok, assign(socket, match: match, games: results, fun1: 0, fun2: 0, winner: 0, sure: false, balance: 0, turns: 0, tags: tags)}
  end


  @impl true
  def handle_event("add", %{"winner" => _winner} = data, socket) do
    game = create_game(socket.assigns.match, data)
    IO.inspect data, label: "data"
    sorted_games = socket.assigns.games ++ [game]
      |> Enum.sort(fn r1, r2 -> r1.time < r2.time end)
    {:noreply, assign(socket, games: sorted_games)}
  end

  @impl true
  def handle_event("add", _data, socket) do
    {:noreply, put_flash(socket, :end_feedback, "Winner must be selected")}
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
      {:error, msg} ->
        {:noreply, put_flash(socket, :end_feedback, msg)}
      _msg ->
          match = Miew.read_match(socket.assigns.match.id)
          {:noreply, assign(socket, match: match)}
    end
  end


  defp create_game(match, input_data) do

    game_data = match
      |> to_atom_game_data()
      |> add_winner(input_data)
      |> add_eval_1(input_data)
      |> add_eval_2(input_data)
      |> add_balance(input_data)
      |> add_turns(input_data)

    case Miew.create_game(game_data) do
      {:error, msg} ->
        {:error, msg}
        %{error: "Error", msg: msg}
      game_id ->
        result_ids = Miew.get(game_id, :game).results
        results = Miew.list_results(result_ids)

        %{
          id: game_id,
          turns: game_data.turns,
          time: Metr.Time.timestamp(),
          results: [
            %{
              player_id: match.player_one,
              deck_id: match.deck_one,
              place: place(1, game_data.winner),
              fun: game_data.fun_1,
              power: power(game_data.balance, 1),
              tags: [add_tag(results, input_data, 1)]
            },
            %{
              player_id: match.player_two,
              deck_id: match.deck_two,
              place: place(2, game_data.winner),
              fun: game_data.fun_2,
              power: power(game_data.balance, 2),
              tags: [add_tag(results, input_data, 2)]
            }
          ]
        }
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
      eval_1: nil, eval_2: nil,
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
        |> Map.put(:power_1, input_data["pow1"] |> Helpers.text_to_integer())
        |> Map.put(:fun_1, input_data["fun1"] |> Helpers.text_to_integer())
      _ ->
        match
    end
  end


  defp add_eval_2(match, input_data) do
    case Helpers.text_to_bool(input_data["eval2"]) do
      true ->
        match
        |> Map.put(:power_2, input_data["pow2"] |> Helpers.text_to_integer())
        |> Map.put(:fun_2, input_data["fun2"] |> Helpers.text_to_integer())
      _ ->
        match
    end
  end


  defp add_balance(match, input_data) do
    case Integer.parse input_data["balance"] do
      {balance, _} ->
        Map.put(match, :balance, parse_balance(balance))
      _ ->
        {:error, "invalid balance value"}
    end
  end


  defp add_turns(match, input_data) do
    case Integer.parse input_data["turns"] do
      {turns, _} ->
        Map.put(match, :turns, turns)
      _ ->
        Map.put(match, :turns, nil)
    end
  end


  defp place(_participant, 0), do: 0
  defp place(participant, winner) do
    case participant == winner do
      true -> 1
      false -> 2
    end
  end


  defp parse_balance(-2), do: {1,2}
  defp parse_balance(-1), do: {1,1}
  defp parse_balance(0), do: {0,0}
  defp parse_balance(1), do: {2,1}
  defp parse_balance(2), do: {2,2}

  defp power({0,0}, _), do: 0
  defp power({x,1}, x), do: 1
  defp power({x,2}, x), do: 2
  defp power({_x,1}, _y), do: -1
  defp power({_x,2}, _y), do: -2

  defp add_tag(results, input_data, player) do
    tag = input_data["tag#{player}"]
    result_id = Enum.at(results, player-1, nil).id
    add_tag(result_id, tag)
    |> String.capitalize()
  end

  defp add_tag(_result_id, nil) do
    ""
  end
  defp add_tag(result_id, tag) do
    Miew.add_tag(tag, :result, result_id) |> IO.inspect(label: "tag added")
  end

  defp first_tag(result) do
    case Map.get(result, :tags, nil) do
      nil -> ""
      [] -> ""
      [h | _t] -> h
    end
  end
end
