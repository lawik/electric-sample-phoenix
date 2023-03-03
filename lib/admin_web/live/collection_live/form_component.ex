defmodule AdminWeb.CollectionLive.FormComponent do
  use AdminWeb, :live_component

  alias Admin.Content

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage collection records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="collection-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :slug}} type="text" label="Slug" />
        <.input field={{f, :name}} type="text" label="Name" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Collection</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{collection: collection} = assigns, socket) do
    changeset = Content.change_collection(collection)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"collection" => collection_params}, socket) do
    changeset =
      socket.assigns.collection
      |> Content.change_collection(collection_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"collection" => collection_params}, socket) do
    save_collection(socket, socket.assigns.action, collection_params)
  end

  defp save_collection(socket, :edit, collection_params) do
    case Content.update_collection(socket.assigns.collection, collection_params) do
      {:ok, _collection} ->
        {:noreply,
         socket
         |> put_flash(:info, "Collection updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_collection(socket, :new, collection_params) do
    case Content.create_collection(collection_params) do
      {:ok, _collection} ->
        {:noreply,
         socket
         |> put_flash(:info, "Collection created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
