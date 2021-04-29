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
        <p><%= List.first(@changes) |> Kernel.inspect() %>
        <%= for c <- Enum.slice(@changes, 1, Enum.count(@changes)-1) do %>
          ,<%= Kernel.inspect(c) %>
        <% end %>
        <p><%= List.first(@data) |> Kernel.inspect() %>
        <%= for c <- Enum.slice(@data, 1, Enum.count(@data)-1) do %>
          ,<%= Kernel.inspect(c) %>
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
    |> Enum.map(fn e -> e.data.change end)

    plot_data = changes
      |> Enum.reduce([], fn c, acc -> apply_last_change(acc, c) end)

    scale = Contex.ContinuousLinearScale.new()
      |> Contex.ContinuousLinearScale.domain(-2, 10)
      |> Contex.ContinuousLinearScale.interval_count(5)

    options = [
      custom_y_scale: scale,
      colour_palette: ["ff9000"]
    ]


    plot = plot_data
      |> Dataset.new()
      |> Plot.new(LinePlot, 700, 400, options)
      |> Plot.titles("Rank over time", "")
      |> Plot.axis_labels("Game", "Rank")
      |> Plot.to_svg()

    {:ok, assign(socket, deck: deck, changes: changes, plot: plot, data: plot_data)}
  end

  def load_deck(id) do
    Miew.get(id, "deck")
    |> DeckHelper.apply_split_rank()
  end

  defp apply_last_change([], change) do
    [{1, 0}, {2, 0 + change}]
  end
  defp apply_last_change(changes, change) do
    {at, last_rank} = List.last(changes)
    changes ++ [{at + 1, last_rank + change}]
  end
end
