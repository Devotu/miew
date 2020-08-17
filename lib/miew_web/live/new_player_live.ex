defmodule MiewWeb.NewPlayerLive do
  use MiewWeb, :live_view

  alias Metr

  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <p><%= assigns.name_added %>
    </section>
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
    {:ok, assign(socket, name: "", name_added: "")}
  end


  @impl true
  @spec handle_event(<<_::24>>, map, any) :: {:noreply, any}
  def handle_event("add", %{"name" => name}, socket) do
    player_id = Metr.create_player(%{name: name})
    {:noreply, assign(socket, name_added: "Added: " <> name)}
  end
end
