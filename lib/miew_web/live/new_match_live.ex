defmodule MiewWeb.NewMatchLive do
  use MiewWeb, :live_view

  alias Metr

  @default_match %{
    "player_1" => "", "deck_1" => "",
    "player_2" => "", "deck_2" => "",
    "ranking" => :false
  }


  @impl true
  def mount(_params, _session, socket) do
    players = Enum.map(Metr.list_players(), fn p -> p.id end)
    decks = Enum.map(Metr.list_decks(), fn d -> d.id end)

    {:ok, assign(socket,
      player_1: "", player_2: "",
      deck_1: "", deck_2: "",
      players: players,
      decks: decks,
      ranking: :false
    )}
  end


  @impl true
  def handle_event("create", %{} = data, socket) do
    Map.merge(@default_match, data)
    |> to_atom_match_data()
    |> Miew.create_match()

    {:noreply, socket}
  end


  defp to_atom_match_data(m) do
    %{
      player_1_id: m["player_1"], player_2_id: m["player_2"],
      deck_1_id: m["deck_1"], deck_2_id: m["deck_2"],
      ranking: bool(m["ranking"])
    }
  end

  defp bool(term) do
    case term do
      true -> true
      "true" -> true
      _ -> false
    end
  end
end