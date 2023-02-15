defmodule AdminWeb.TodoLive.Index do
  use AdminWeb, :live_view

  alias Admin.Focus
  alias Admin.Focus.Todo

  @impl true
  def mount(_params, _session, socket) do
    Cainophile.Adapters.Postgres.subscribe(Cainophile.ExamplePublisher, self())
    {:ok, assign(socket, :todos, list_todos())}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  @impl true
  def handle_info(%Cainophile.Changes.Transaction{}, socket) do
    {:noreply, assign(socket, :todos, list_todos())}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Focus.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Focus.get_todo!(id)
    {:ok, _} = Focus.delete_todo(todo)

    {:noreply, assign(socket, :todos, list_todos())}
  end

  defp list_todos do
    Focus.list_todos()
  end
end
