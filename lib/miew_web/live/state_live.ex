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
    state = Metr.read_state(type, id)
    {:ok, assign(socket, state: state, type: type)}
  end

  @impl true
  def handle_event("rerun", %{"id" => id, "type" => type}, socket) do
    case Metr.rerun(type, id) do
      :ok -> {:noreply, put_flash(socket, :rerun_ok, "Ok!")}
      {:error, e} -> {:noreply, put_flash(socket, :rerun_error, Kernel.inspect(e))}
      x -> {:noreply, put_flash(socket, :rerun_error, "Unkown error #{Kernel.inspect(x)}")}
    end
  end
end
