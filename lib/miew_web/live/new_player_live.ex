defmodule MiewWeb.NewPlayerLive do
  use MiewWeb, :live_view

  alias Metr.Modules.Input.PlayerInput

  @impl true
  def render(assigns) do
    ~L"""
    <section>
      <p><%= assigns.name_added %>
    </section>
    <section>
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
    case Miew.create_player(%PlayerInput{name: name}) do
      {:error, msg} ->
        {:noreply, assign(socket, name_added: "Error: " <> msg)}
      _ ->
        {:noreply, assign(socket, name_added: "Added: " <> name)}
    end

  end
end
