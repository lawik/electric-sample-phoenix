defmodule AdminWeb.TodoListLive.Index do
  use AdminWeb, :live_view

  alias Admin.Focus
  alias Admin.Focus.TodoList

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign(socket, :todolist, list_todolist())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo list")
    |> assign(:todo_list, Focus.get_todo_list!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo list")
    |> assign(:todo_list, %TodoList{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todolist")
    |> assign(:todo_list, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo_list = Focus.get_todo_list!(id)
    {:ok, _} = Focus.delete_todo_list(todo_list)

    {:noreply, assign(socket, :todolist, list_todolist())}
  end

  defp list_todolist do
    Focus.list_todolist()
  end
end
