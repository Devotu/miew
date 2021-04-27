defmodule MiewWeb.StateLive do
  use MiewWeb, :live_view

  alias Metr
  alias Miew.Helpers

  @impl true
  def render(assigns) do
    ~L"""
    <section class="plaque v-fill">
      <p class="alert alert-warning"><%= live_flash(@flash, :rerun_error) %></p>
      <p class="alert alert-success"><%= live_flash(@flash, :rerun_ok) %></p>
      <pre><%= pretty(@state, assigns) %></pre>
    </section>
    <section>
      <div class="flex flex-spread row append-b">
        <%= if @confirm do %>
        <button
          class="flexi box-fill-w confirm"
          type="button"
          phx-click="confirm"
          phx-value-id="<%=@state.id%>"
          phx-value-type="<%=@type%>"
          >Confirm</button>
        <% else %>
        <button
          class="flexi box-fill-w"
          type="button"
          phx-click="ask_confirm"
          phx-value-id="<%=@state.id%>"
          phx-value-type="<%=@type%>"
          >Rerun</button>
        <% end %>
      </div>
    </section>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    type = params["type"] |> Miew.type_from_string()
    id = params["id"]
    state = load_state(type, id)
    {:ok, assign(socket, state: state, type: type, confirm: false)}
  end

  @impl true
  def handle_event("ask_confirm", %{"id" => id, "type" => type}, socket) do
    {:noreply, assign(socket, state: load_state(type, id), type: type, confirm: true)}
  end

  @impl true
  def handle_event("confirm", %{"id" => id, "type" => type}, socket) do
    state = load_state(type, id)
    case Metr.rerun(type, id) do
      :ok -> {:noreply, put_flash(socket, :rerun_ok, "Ok")}
      {:error, e} -> {:noreply, put_flash(socket, :rerun_error, Kernel.inspect(e))}
      x -> {:noreply, put_flash(socket, :rerun_error, "Unkown error #{Kernel.inspect(x)}")}
    end
  end

  defp load_state(type, id) do
    Metr.read_state(type, id)
  end

  defp pretty(state, assigns) do
    Helpers.to_pretty(state)
  end
end
