defmodule Miew do

  def create_player(%{name: _} = data) do
    Metr.create_player(data)
  end

  def create_deck(%{name: _, player_id: _} = data) do
    Metr.create_deck(data)
  end

  def create_game(%{deck_1: _d1, deck_2: _d2, player_1: _p1, player_2: _p2, winner: _w} = data) do
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

  def list(type) when is_bitstring(type) do
    Metr.list_states(type)
  end

  def list_formats() do
    Metr.list_formats()
  end

  def get(id, type) when is_bitstring(id) and is_bitstring(type) do
    Metr.read_state(type, id)
  end

  def bump_rank(deck_id, :up) when is_bitstring(deck_id), do: Metr.alter_rank(deck_id, :up)
  def bump_rank(deck_id, :down) when is_bitstring(deck_id), do: Metr.alter_rank(deck_id, :down)
end
