defmodule MiewWeb.DeckHelper do
  def apply_split_rank(%{rank: nil} = deck) do
    deck
    |> Map.put(:rank, 0)
    |> Map.put(:advantage, 0)
  end

  def apply_split_rank(%{} = deck) do
    {rank, advantage} = deck.rank
    deck
    |> Map.put(:rank, rank)
    |> Map.put(:advantage, advantage)
  end
end
