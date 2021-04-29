defmodule MiewWeb.DeckRankLive do
  use MiewWeb, :live_view

  alias Miew
  alias MiewWeb.DeckHelper
  alias Contex.Plot
  alias Contex.LinePlot
  alias Contex.Dataset

  @impl true
  def render(assigns) do
    ~L"""
    <section class="plaque v-space">
      <div>
        <ul class="v-list header">
          <li class="label">
            <span class="v-list-item"><%= @deck.rank %>/<%= @deck.advantage %></span>
          </li>
        </ul>
        <p><%= List.first(@changes) %>
        <%= for c <- Enum.slice(@changes, 1, Enum.count(@changes)-1) do %>
          ,<%= c %>
        <% end %>
      </div>
    </section>
    <section class="plaque">
      <%= @plot %>
    </section>
    <section class="footer">
      <ul class="h-list">
        <li><%= link("Modify rank", method: :get, to: "/deck/#{@deck.id}/rank/adjust")%></li>
      </ul>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    deck = params["id"]
      |> load_deck

    changes = deck.id
    |> Miew.read_log(:deck)
    |> Enum.filter(&match?([:alter, :rank], &1.keys))
    |> IO.inspect(label: "deck rank log")
    |> Enum.map(fn e -> e.data.change end)
    # |> Enum.reduce({[], 0}, fn c, acc -> acc ++ [{c, }] end)

    scale = Contex.ContinuousLinearScale.new()
      |> Contex.ContinuousLinearScale.domain(-2, 2)
      |> Contex.ContinuousLinearScale.interval_count(5)

    options = [custom_y_scale: scale]

    line_data = [{1, -1}, {2, 2}, {3, 2}, {4, 1}]
      |> Dataset.new()


    plot = Plot.new(line_data, LinePlot, 700, 400, options)
      |> Plot.titles("Rank over time", "")
      |> Plot.axis_labels("Game", "Rank")
      |> Plot.to_svg()

    {:ok, assign(socket, deck: deck, changes: changes, plot: plot)}
  end

  def load_deck(id) do
    Miew.get(id, "deck")
    |> DeckHelper.apply_split_rank()
  end
end
