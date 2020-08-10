defmodule MiewWeb.DeckGamesLive do
  use MiewWeb, :live_view

  defstruct vs_deck: nil, vs_player: nil, power: nil, fun: nil, z_winrate: 50, z_power: 0, z_fun: 0

  alias MiewWeb.DeckGamesLive

  @impl true
  def mount(params, _session, socket) do
    deck_id = params["id"]

    games = Metr.list_games(:deck, deck_id)
      |> IO.inspect(label: "deck games live - input")
     |> Enum.sort(&(&1.time < &2.time))
     |> Enum.map(fn g -> {find_selected(g.participants, deck_id), find_opponent(g.participants, deck_id)} end)
     |> IO.inspect(label: "deck games live - self/opponent")
     |> Enum.map(fn {selected, opponent} ->
      %DeckGamesLive{
        vs_deck: opponent.deck_id,
        vs_player: opponent.player_id,
        power: selected.power,
        fun: selected.fun,
        z_winrate: 0,
        z_power: 0,
        z_fun: 0
      }
     end)
     |> IO.inspect(label: "deck games live - struct")



    {:ok, assign(socket, games: games)}
  end


  defp find_selected(participants, deck_id) do
    participants
    |> Enum.filter(fn p -> p.deck_id == deck_id end)
    |> List.first()
  end

  defp find_opponent(participants, deck_id) do
    participants
    |> Enum.filter(fn p -> p.deck_id != deck_id end)
    |> List.first()
  end
end
