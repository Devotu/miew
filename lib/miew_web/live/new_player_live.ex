defmodule MiewWeb.NewPlayerLive do
  use MiewWeb, :live_view

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <form phx-submit="add">
        <input type="text" name="name" value="<%= @name %>" placeholder="Name"/>
        <button type="submit" phx-disable-with="Adding...">Add</button>
      </form>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, name: "")}
  end


  @impl true
  @spec handle_event(<<_::24>>, map, any) :: {:noreply, any}
  def handle_event("add", %{"name" => name}, socket) do
    IO.puts(name)
    {:noreply, socket}
  end
end
