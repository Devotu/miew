defmodule Miew do

  def create_player(%{name: _} = data) do
    Metr.create_player(data)
  end

  def create_deck(%{name: _, player_id: _} = data) do
    Metr.create_deck(data)
  end

  def create_game(%{deck_1: _d1, deck_2: _d2, player_1: _p1, player_2: _p2, winner: _w, turns: _t} = data) do
    Metr.create_game(data)
  end


  def create_match(%{deck_1_id: _, player_1_id: _, deck_2_id: _, player_2_id: _, ranking: _ranking} = data) do
    Metr.create_match(data)
  end

  def list_matches() do
    Metr.list_matches()
  end

  def read_match(id) do
    Metr.read_match(id)
  end

  def end_match(id) do
    Metr.end_match(id)
  end


  def list_games(game_ids) when is_list(game_ids) do
    Metr.list_games(game_ids)
  end


  def list(type, ids) when is_atom(type) and is_list(ids) do
    Metr.list_states(ids, type)
  end

  def list(ids, type) when is_atom(type) and is_list(ids) do
    Metr.list_states(ids, type)
  end

  def list("deck", sort: "name") do
    Metr.list_states("deck")
    |> Enum.sort(fn a, b -> a.name < b.name end)
  end

  def list("deck", sort: "games") do
    Metr.list_states("deck")
    |> Enum.sort(fn a, b -> Enum.count(a.results) > Enum.count(b.results) end)
  end

  def list("deck", sort: "rank") do
    Metr.list_states("deck")
    |> Enum.map(fn d -> Map.put(d, :flatrank, flat_rank(d.rank)) end)
    |> Enum.sort(fn a, b -> a.flatrank > b.flatrank end)
  end

  def list(type) when is_bitstring(type) do
    Metr.list_states(type)
  end

  def list_formats() do
    Metr.list_formats()
  end

  def get(id, type) when is_bitstring(id) and is_bitstring(type) do
    Metr.read_state(type, id)
  end

  @spec bump_rank(bitstring, :down | :up) :: any
  def bump_rank(deck_id, :up) when is_bitstring(deck_id), do: Metr.alter_rank(deck_id, :up)
  def bump_rank(deck_id, :down) when is_bitstring(deck_id), do: Metr.alter_rank(deck_id, :down)

  def type_from_string(type_string) do
    case type_string do
      "player" ->
        :player
      "deck" ->
        :deck
      "match" ->
        :match
      "game" ->
        :game
      "result" ->
        :result
    end
  end

  def read_entity_history(id, type) do
    Metr.read_entity_history(id, type)
  end


  defp flat_rank({rank, advantage}) do
    (3*rank) + advantage
  end
  defp flat_rank(nil) do
    0
  end

  def read_log(id, type) when is_atom(type) and is_bitstring(id) do
    Metr.read_entity_log(type, id)
  end
end
