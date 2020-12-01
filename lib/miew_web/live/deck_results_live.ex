defmodule MiewWeb.DeckResultsLive do
  use MiewWeb, :live_view

  defstruct z_winrate: 50, z_power: 0, z_fun: 0

  @impl true
  def mount(params, _session, socket) do
    deck_id = params["id"]

    deck = Miew.get(deck_id, "deck")

    results = Miew.list(:result, deck.results)
      |> Enum.sort(&(&1.time < &2.time))

    {:ok, assign(socket, results: results)}
  end
end
