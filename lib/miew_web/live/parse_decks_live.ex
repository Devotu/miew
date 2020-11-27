defmodule MiewWeb.ParseDecksLive do
  use MiewWeb, :live_view

  alias Miew.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, decks: [], msg: "")}
  end


  @impl true
  def handle_event("parse", %{"data" => data}, socket) do
    parsed = data
      |> String.split(",")
      |> Enum.map(&(String.split(&1, ";")))
      |> Enum.map(fn x -> pick_apart(x, Miew.list_formats()) end)

    {:noreply, assign(socket, decks: parsed)}
  end


  @impl true
  def handle_event("apply", %{} = data, socket) do
    msg = data
      |> to_atom_deck_data()
      |> Miew.create_deck()
    {:noreply, assign(socket, msg: msg)}
  end


  defp pick_apart([price, format, name, creator, red, green, white, black, blue], known_formats) do
    %{
      name: name,
      format: parse_format(format, known_formats),
      theme: "",
      owner: String.downcase(creator),
      black: Helpers.text_to_bool(black),
      white: Helpers.text_to_bool(white),
      red: Helpers.text_to_bool(red),
      green: Helpers.text_to_bool(green),
      blue: Helpers.text_to_bool(blue),
      colorless: false,
      price: Helpers.text_to_number(price)
    }
  end


  defp parse_format(input_text, known_formats) do
    input_text
      |> String.downcase()
      |> by_known_format(known_formats)
  end

  defp by_known_format(text, known_formats) do
    case Enum.member?(known_formats, text) do
      true -> text
      false -> "Unknown format #{text}"
    end
  end


  defp to_atom_deck_data(m) do
    %{
      player_id: m["owner"],
      name: m["name"], format: m["format"], theme: m["theme"],
      black: bool(m["black"]), white: bool(m["white"]), red: bool(m["red"]),
      green: bool(m["green"]), blue: bool(m["blue"]), colorless: bool(m["colorless"]),
      rank: 0, advantage: 0, price: m["price"]
    }
  end

  defp bool(term) do
    Helpers.text_to_bool(term)
  end
end
