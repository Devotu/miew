defmodule MiewWeb.StateLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <%= Kernel.inspect(@state) %>
    </section>
    <section>
      <button phx-click="rerun" phx-value-id="<%=@state.id%>" phx-value-type="<%=@type%>">Rerun</button>
      <p class="alert alert-warning"><%= live_flash(@flash, :rerun_error) %></p>
      <p class="alert alert-success"><%= live_flash(@flash, :rerun_ok) %></p>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    type = params["type"] |> Metr.type_from_string()
    id = params["id"]
    player_state = Metr.read_state(type, id)
    {:ok, assign(socket, state: player_state)}
  end
end
