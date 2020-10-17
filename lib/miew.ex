defmodule Miew do

  def create_player(%{name: _} = data) do
    Metr.create_player(data)
  end

  def create_deck(%{name: _, player_id: _} = data) do
    Metr.create_deck(data)
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


  def list_games(game_ids) when is_list(game_ids) do
    Metr.list_games(game_ids)
  end
end
