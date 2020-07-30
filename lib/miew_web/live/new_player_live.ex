defmodule MiewWeb.NewPlayer do
  use MiewWeb, :live_view

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <form phx-submit="new">
        <input type="text" name="name" value="<%= @player_name %>" placeholder="Name"/>
      </form>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end


  @impl true
  def handle_event("new", %{"player_name" => name}, socket) do
    IO.puts(name)
    {:noreply, socket}
  end
end
