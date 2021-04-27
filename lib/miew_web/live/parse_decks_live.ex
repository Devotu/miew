defmodule MiewWeb.ParseDecksLive do
  use MiewWeb, :live_view

  alias Miew.Helpers

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, decks: [], msg: "")}
  end


  @impl true
  def handle_event("parse", %{"data" => data}, socket) do
    {:noreply, assign(socket, decks: parse(data))}
  end

  @impl true
  def handle_event("apply", %{"input" => input}, socket) do
    result = input
      |> parse()
      |> Enum.map(fn d -> Miew.create_deck(d) end)
    {:noreply, assign(socket, msg: Kernel.inspect(result))}
  end


  defp pick_apart([price, format, name, creator, theme, red, green, white, black, blue], known_formats) do
    %{
      name: name,
      format: parse_format(format, known_formats),
      player_id: String.downcase(creator),
      black: Helpers.text_to_bool(black),
      white: Helpers.text_to_bool(white),
      red: Helpers.text_to_bool(red),
      green: Helpers.text_to_bool(green),
      blue: Helpers.text_to_bool(blue),
      colorless: false,
      price: price |> String.trim() |> Helpers.text_to_number(),
      theme: theme
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

  defp parse(input) do
    input
    |> String.split(",")
    |> Enum.map(&(String.split(&1, ";")))
    |> Enum.map(fn x -> pick_apart(x, Miew.list_formats()) end)
  end
end
