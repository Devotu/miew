defmodule MiewWeb.ParseDecksLive do
  use MiewWeb, :live_view

  alias Metr

  @default_deck %{
    name: "name", format: "format", theme: "tema",
    black: false, white: false, red: false,
    green: false, blue: false, colorless: false
  }


  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, decks: [], msg: "")}
  end


  @impl true
  def handle_event("parse", %{} = data, socket) do
    output = [@default_deck]
    {:noreply, assign(socket, decks: output)}
  end


  @impl true
  def handle_event("apply", %{} = data, socket) do
    msg = "Här kommer output att vara"
    {:noreply, assign(socket, msg: msg)}
  end
end
