defmodule MiewWeb.NewDeckLive do
  use MiewWeb, :live_view

  alias Metr.Modules.Input.DeckInput
  alias Miew.Helpers

  @impl true
  def mount(_params, _session, socket) do
    players = Enum.map(Miew.list_players(), fn p -> p.id end)
    formats = Miew.list_formats()

    {:ok, assign(socket, players: players, formats: formats)}
  end


  @impl true
  def handle_event("add", %{} = data, socket) do
    response = data
    |> to_deck_input()
    |> Miew.create_deck()

    case response do
      {:error, msg} ->
        {:noreply, put_flash(socket, :create_feedback, msg)}
      id ->
        deck = Miew.get(id, :deck)
        {:noreply, put_flash(socket, :create_feedback, "#{deck.name} added")}
    end
  end


  defp to_deck_input(m) do
    %DeckInput{
      player_id: m["player_id"],
      name: m["name"], format: m["format"], theme: m["theme"],
      black: bool(m["black"]), white: bool(m["white"]), red: bool(m["red"]),
      green: bool(m["green"]), blue: bool(m["blue"]), colorless: bool(m["colorless"]),
      price: m["price"]
    }
  end

  defp bool(term) do
    Helpers.text_to_bool(term)
  end
end
