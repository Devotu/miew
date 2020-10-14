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
end
