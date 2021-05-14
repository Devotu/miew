defmodule MiewWeb.NewMatchLive do
  use MiewWeb, :live_view

  alias Metr.Modules.Input.MatchInput

  @default_match %{
    "player_1" => "", "deck_1" => "",
    "player_2" => "", "deck_2" => "",
    "ranking" => :false
  }


  @impl true
  @spec mount(any, any, Phoenix.LiveView.Socket.t()) :: {:ok, any}
  def mount(_params, _session, socket) do
    players = Enum.map(Miew.list_players(), fn p -> p.id end)
    decks = Enum.map(Miew.list_decks(sort: "name"), fn d -> d.id end)

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
    response = Map.merge(@default_match, data)
    |> to_match_input()
    |> Miew.create_match()

    case response do
      {:error, msg} ->
        {:noreply, put_flash(socket, :create_feedback, msg)}
      id ->
        {:noreply, redirect(socket, to: "/match/#{id}")}
    end
  end


  defp to_match_input(m) do
    %MatchInput{
      player_one: m["player_1"], player_two: m["player_2"],
      deck_one: m["deck_1"], deck_two: m["deck_2"],
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
