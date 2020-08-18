defmodule Miew do

  def create_player(%{name: _} = data) do
    Metr.create_player(data)
  end

  def create_deck(%{name: _, player_id: _} = data) do
    Metr.create_deck(data)
  end
end
