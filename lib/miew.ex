defmodule Miew do

  alias Miew.Helpers.GameHelpers
  alias Metr.Modules.Input.DeckInput
  alias Metr.Modules.Input.MatchInput
  alias Metr.Modules.Input.PlayerInput

  ## Create
  def create_player(%PlayerInput{} = data) do
    Metr.create(data, :player)
  end

  def create_deck(%DeckInput{} = data) do
    Metr.create(data, :deck)
  end

  def create_game(%{deck_1: _d1, deck_2: _d2, player_1: _p1, player_2: _p2, winner: _w} = data) do
    data
    |> GameHelpers.to_game_input()
    |> Metr.create(:game)
  end


  def create_match(%MatchInput{} = data) do
    Metr.create(data, :match)
  end

  ## List
  def list(type) when is_atom(type) do
    Metr.list(type)
  end

  def list_formats() do
    Metr.list(:format)
  end

  def list_players() do
    Metr.list(:player)
  end

  def list_players(ids) when is_list(ids) do
    Metr.list(ids, :player)
  end

  def list_decks() do
    Metr.list(:deck)
  end

  def list_decks(sort: "name") do
    Metr.list(:deck)
    |> Enum.sort(fn a, b -> a.name < b.name end)
  end

  def list_decks(sort: "games") do
    Metr.list(:deck)
    |> Enum.sort(fn a, b -> Enum.count(a.results) > Enum.count(b.results) end)
  end

  def list_decks(sort: "rank") do
    Metr.list(:deck)
    |> Enum.map(fn d -> Map.put(d, :flatrank, flat_rank(d.rank)) end)
    |> Enum.sort(fn a, b -> a.flatrank > b.flatrank end)
  end

  def list_decks(ids) when is_list(ids) do
    Metr.list(ids, :deck)
  end

  def list_games() do
    Metr.list(:game)
  end

  def list_games(ids) when is_list(ids) do
    Metr.list(ids, :game)
  end

  def list_matches() do
    Metr.list(:match)
  end

  def list_matches(ids) when is_list(ids) do
    Metr.list(ids, :match)
  end

  def list_results() do
    Metr.list(:result)
  end

  def list_results(ids) when is_list(ids) do
    Metr.list(ids, :result)
  end

  ## Read

  def read_match(id) do
    Metr.read(id, :match)
  end

  def get(id, type) when is_bitstring(id) and is_atom(type) do
    Metr.read(id, type)
  end


  ## Functions

  def end_match(id) do
    Metr.end_match(id)
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
      "tag" ->
        :tag
    end
  end

  def list_types() do
    ~w(player deck match game result tag)
  end


  defp flat_rank({rank, advantage}) do
    (3*rank) + advantage
  end
  defp flat_rank(nil) do
    0
  end

  def read_log(id, type) when is_atom(type) and is_bitstring(id) do
    Metr.read_log(id, type)
  end

  def list_game_conclusion_tags() do
    ~w(Mana Speed Endurance Control Versatility Power Growth Draw Synergy)
  end

  def add_tag(tag, target_type, target_id) when is_bitstring(tag) and is_atom(target_type) and is_bitstring(target_id) do
    Metr.add_tag(tag, target_type, target_id)
  end
end
