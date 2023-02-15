defmodule AdminWeb.TodoListLive.FormComponent do
  use AdminWeb, :live_component

  alias Admin.Focus

  @impl true
  def render(assigns) do
    ~H"""
    <div>
      <.header>
        <%= @title %>
        <:subtitle>Use this form to manage todo_list records in your database.</:subtitle>
      </.header>

      <.simple_form
        :let={f}
        for={@changeset}
        id="todo_list-form"
        phx-target={@myself}
        phx-change="validate"
        phx-submit="save"
      >
        <.input field={{f, :filter}} type="text" label="Filter" />
        <.input field={{f, :editing}} type="text" label="Editing" />
        <:actions>
          <.button phx-disable-with="Saving...">Save Todo list</.button>
        </:actions>
      </.simple_form>
    </div>
    """
  end

  @impl true
  def update(%{todo_list: todo_list} = assigns, socket) do
    changeset = Focus.change_todo_list(todo_list)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"todo_list" => todo_list_params}, socket) do
    changeset =
      socket.assigns.todo_list
      |> Focus.change_todo_list(todo_list_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"todo_list" => todo_list_params}, socket) do
    save_todo_list(socket, socket.assigns.action, todo_list_params)
  end

  defp save_todo_list(socket, :edit, todo_list_params) do
    case Focus.update_todo_list(socket.assigns.todo_list, todo_list_params) do
      {:ok, _todo_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo list updated successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_todo_list(socket, :new, todo_list_params) do
    case Focus.create_todo_list(todo_list_params) do
      {:ok, _todo_list} ->
        {:noreply,
         socket
         |> put_flash(:info, "Todo list created successfully")
         |> push_navigate(to: socket.assigns.navigate)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
