defmodule MiewWeb.NewDeckLive do
  use MiewWeb, :live_view

  alias Metr
  alias Miew.Helpers

  @default_deck %{
    "format" => "", "theme" => "",
    "black" => "false", "white" => "false", "red" => "false",
    "green" => "false", "blue" => "false", "colorless" => "false",
    "rank" => 0, "advantage" => 0
  }


  @impl true
  def mount(_params, _session, socket) do
    players = Enum.map(Miew.list("player"), fn p -> p.id end)
    formats = Miew.list_formats()

    {:ok, assign(socket,
    owner: "",
    name: "", format: "", theme: "",
    price: 0,
    black: false, white: false, red: false,
    green: false, blue: false, colorless: false,
    players: players,
    formats: formats,
    rank: 0,
    advantage: 0,
    name_added: ""
    )}
  end


  @impl true
  def handle_event("add", %{} = data, socket) do
    Map.merge(@default_deck, data)
    |> to_atom_deck_data()
    |> Miew.create_deck()

    {:noreply, assign(socket, name_added: "Added: " <> data["name"])}
  end


  defp to_atom_deck_data(m) do
    %{
      player_id: m["owner"],
      name: m["name"], format: m["format"], theme: m["theme"],
      black: bool(m["black"]), white: bool(m["white"]), red: bool(m["red"]),
      green: bool(m["green"]), blue: bool(m["blue"]), colorless: bool(m["colorless"]),
      rank: m["rank"], advantage: m["advantage"],
      price: m["price"]
    }
  end

  defp bool(term) do
    Helpers.text_to_bool(term)
  end
end
