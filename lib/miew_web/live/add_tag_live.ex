defmodule MiewWeb.AddTagLive do
  use MiewWeb, :live_view

  alias Metr

  @impl true
  def render(assigns) do
    ~L"""
    <section class="plaque v-space-t">
      <form phx-submit="add" phx-change="update">
        <div class="clicksize">
          <p class="label v-space">Object:
            <select name="type" id="type" placeholder="type">
              <option value="" disabled selected>*</option>
              <%= for type <- @types do %>
                <option value="<%= type %>"><%= type %></option>
              <% end %>
            </select>
          </p>
        </div>
        <div class="clicksize">
          <p class="label v-space">Target:
            <select name="target_id" id="target">
              <option value="" disabled selected>*</option>
              <%= for target <- @targets do %>
                <option value="<%= target.id %>"><%= target.name %></option>
              <% end %>
            </select>
          </p>
        </div>
        <div class="clicksize">
          <p class="label v-space">Tag:
            <div class="">
              <input class="" type="text" name="tag" value="" placeholder="name"/>
            </div>
          </p>
        </div>
        <div class="flex flex-spread row append-b flex-right-row">
          <button class="flexi box-fill" type="submit" phx-disable-with="Adding...">Create</button>
        </div>
      </form>
    </section>

    <section class="v-space-tl footer">
      <p class="alert alert-warning"><%= live_flash(@flash, :feedback) %></p>
    </section>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    target_types =
      Miew.list_types()
      |> Enum.filter(&(&1 != "tag"))

    {:ok, assign(socket, types: target_types, targets: [])}
  end

  @impl true
  def handle_event("update", data, socket) do
    targets =
      data["type"]
      |> Miew.type_from_string()
      |> Miew.list()
      |> Enum.map(&build_names/1)
      |> sort(data["type"])
      |> strip()

    {:noreply,
     assign(socket,
       types: Miew.list_types(),
       targets: targets
     )}
  end

  @impl true
  def handle_event("add", %{"type" => type, "target_id" => target_id, "tag" => tag}, socket) do
    expected_tag_id =
      tag
      |> String.downcase()
      |> String.replace(" ", "_")

    case Miew.add_tag(tag, Miew.type_from_string(type), target_id) do
      {:error, e} ->
        {:noreply, put_flash(socket, :error, "#{tag} not added,  #{e}")}

      expected_tag_id ->
        {:noreply, put_flash(socket, :feedback, "#{tag} added to #{type} #{target_id}")}

      x ->
        {:noreply, put_flash(socket, :error, "#{tag} might have been added")}
    end
  end

  defp build_names(target) do
    case Map.has_key?(target, :name) do
      true -> target
      _ -> Map.put(target, :name, target.id)
    end
  end

  defp sort(targets, type) do
    case List.first(targets).id == List.first(targets).name do
      true ->
        Enum.sort(targets, fn a, b -> a.time > b.time end)
      _ ->
          Enum.sort(targets, fn a, b -> a.name < b.name end)
    end
  end

  defp strip(targets) do
    targets
    |> Enum.map(fn t -> %{id: t.id, name: t.name} end)
  end
end
