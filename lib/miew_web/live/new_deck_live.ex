defmodule MiewWeb.NewDeckLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def mount(_params, _session, socket) do
    players = Enum.map(Metr.list_players(), fn p -> p.id end)

    {:ok, assign(socket,
    owner: "",
    name: "", format: "", theme: "",
    price: 0,
    black: false, white: false, red: false,
    green: false, blue: false, colorless: false,
    players: players
    )}
  end


  @impl true
  def handle_event("add", %{} = data, socket) do
    IO.inspect(data, label: "new deck live - submitted")
    {:noreply, socket}
  end
end
