defmodule MiewWeb.DeckRankAdjustLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <form phx-submit="adjust">
        <table>
          <tr>
            <th>Name</td>
            <th>Rank</td>
            <th>+/-</td>
            <th>Advantage</td>
            <th>+/-</td>
          </tr>
          <tr>
            <td><%= @deck.name %></td>
            <td><%= @deck.rank %></td>
            <td>
              <input type="range" name="rank" value="0" min="-1" max="1"/>
            </td>
            <td><%= @deck.advantage %></td>
            <td>
              <input type="range" name="advantage" value="0" min="-1" max="1"/>
            </td>
          </tr>
        </table>
        <button type="submit" phx-disable-with="Adjusting...">Adjust</button>
      </form>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    id = params["id"]
    deck = Metr.read_deck(id)
    deck_with_rank = apply_split_rank(deck)
    {:ok, assign(socket, deck: deck_with_rank)}
  end


  @impl true
  def handle_event("adjust", %{} = data, socket) do
    IO.puts(Kernel.inspect(data))
    {:noreply, socket}
  end

  defp apply_split_rank(%{rank: nil} = deck) do
    deck
    |> Map.put(:rank, 0)
    |> Map.put(:advantage, 0)
  end

  defp apply_split_rank(deck) do
    {rank, advantage} = deck.rank
    deck
    |> Map.put(:rank, rank)
    |> Map.put(:advantage, advantage)
  end
end
