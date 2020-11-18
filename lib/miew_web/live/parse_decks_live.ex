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
      |> Enum.map(&pick_apart/1)

    {:noreply, assign(socket, decks: parsed)}
  end


  @impl true
  def handle_event("apply", %{} = data, socket) do
    IO.inspect(data, label: "apply data")
    msg = "Här kommer output att vara"
    {:noreply, assign(socket, msg: msg)}
  end


  defp pick_apart([price, format, name, creator, red, green, white, black, blue]) do
    %{
      name: name,
      format: format,
      theme: "",
      creator: creator,
      black: Helpers.text_to_bool(black),
      white: Helpers.text_to_bool(white),
      red: Helpers.text_to_bool(red),
      green: Helpers.text_to_bool(green),
      blue: Helpers.text_to_bool(blue),
      colorless: false,
      price: Helpers.text_to_number(price)
    }
  end
end
