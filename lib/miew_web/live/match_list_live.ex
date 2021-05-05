defmodule MiewWeb.MatchListLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <ul class="v-list header">
        <li class="matchlist label">
          <span class="v-list-item">Id</span>
          <span class="v-list-item cut">Status</span>
          <span class="v-list-item">Rank</span>
          <span class="v-list-item">Deck 1</span>
          <span class="v-list-item">Deck 2</span>
          <span class="v-list-item cut">Games</span>
        </li>
      </ul>
      <ul class="v-list">
      <%= for match <- @matches do %>
        <li class="matchlist clicksize">
          <%= link(match.id, method: :get, to: "/match/#{match.id}", class: "v-list-item cut")%>
          <span class="v-list-item"><%= display_status(match.status, assigns) %></span>
          <span class="v-list-item"><%= display_rank(match.ranking, assigns) %></span>
          <span class="v-list-item cut"><%= match.deck_one %></span>
          <span class="v-list-item cut"><%= match.deck_two %></span>
          <span class="v-list-item"><%= Kernel.inspect(Enum.count(match.games)) %></span>
        </li>
      <% end %>
      </ul>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    matches = Miew.list_matches()
      |> Enum.sort(fn m1, m2 -> m1.time > m2.time end)
    {:ok, assign(socket, matches: matches)}
  end

  defp display_status(status, assigns) when is_atom status do
    case status do
      :initialized ->
        ~L"""
        <div class="positive-t cut">new</div>
        """
      :open ->
        ~L"""
        <div class="positive-t cut">live</div>
        """
      :closed ->
        ~L"""
        <div class="negative-t cut">closed</div>
        """
    end
  end

  defp display_rank(true, assigns) do
    ~L"""
    <div class="tickbox">
      <div class="tick"></div>
    </div>
    """
  end
  defp display_rank(false, assigns) do
    ~L"""
    <div class="tickbox"></div>
    """
  end
end
