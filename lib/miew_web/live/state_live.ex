defmodule MiewWeb.StateLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="phx-hero">
      <%= Kernel.inspect(@state) %>
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
