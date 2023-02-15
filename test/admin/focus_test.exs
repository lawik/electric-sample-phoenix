defmodule Admin.FocusTest do
  use Admin.DataCase

  alias Admin.Focus

  describe "todos" do
    alias Admin.Focus.Todo

    import Admin.FocusFixtures

    @invalid_attrs %{completed: nil, listid: nil, text: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Focus.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Focus.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      valid_attrs = %{completed: 42, listid: "some listid", text: "some text"}

      assert {:ok, %Todo{} = todo} = Focus.create_todo(valid_attrs)
      assert todo.completed == 42
      assert todo.listid == "some listid"
      assert todo.text == "some text"
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Focus.create_todo(@invalid_attrs)
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()
      update_attrs = %{completed: 43, listid: "some updated listid", text: "some updated text"}

      assert {:ok, %Todo{} = todo} = Focus.update_todo(todo, update_attrs)
      assert todo.completed == 43
      assert todo.listid == "some updated listid"
      assert todo.text == "some updated text"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Focus.update_todo(todo, @invalid_attrs)
      assert todo == Focus.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Focus.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Focus.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Focus.change_todo(todo)
    end
  end

  describe "todolist" do
    alias Admin.Focus.TodoList

    import Admin.FocusFixtures

    @invalid_attrs %{editing: nil, filter: nil}

    test "list_todolist/0 returns all todolist" do
      todo_list = todo_list_fixture()
      assert Focus.list_todolist() == [todo_list]
    end

    test "get_todo_list!/1 returns the todo_list with given id" do
      todo_list = todo_list_fixture()
      assert Focus.get_todo_list!(todo_list.id) == todo_list
    end

    test "create_todo_list/1 with valid data creates a todo_list" do
      valid_attrs = %{editing: "some editing", filter: "some filter"}

      assert {:ok, %TodoList{} = todo_list} = Focus.create_todo_list(valid_attrs)
      assert todo_list.editing == "some editing"
      assert todo_list.filter == "some filter"
    end

    test "create_todo_list/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Focus.create_todo_list(@invalid_attrs)
    end

    test "update_todo_list/2 with valid data updates the todo_list" do
      todo_list = todo_list_fixture()
      update_attrs = %{editing: "some updated editing", filter: "some updated filter"}

      assert {:ok, %TodoList{} = todo_list} = Focus.update_todo_list(todo_list, update_attrs)
      assert todo_list.editing == "some updated editing"
      assert todo_list.filter == "some updated filter"
    end

    test "update_todo_list/2 with invalid data returns error changeset" do
      todo_list = todo_list_fixture()
      assert {:error, %Ecto.Changeset{}} = Focus.update_todo_list(todo_list, @invalid_attrs)
      assert todo_list == Focus.get_todo_list!(todo_list.id)
    end

    test "delete_todo_list/1 deletes the todo_list" do
      todo_list = todo_list_fixture()
      assert {:ok, %TodoList{}} = Focus.delete_todo_list(todo_list)
      assert_raise Ecto.NoResultsError, fn -> Focus.get_todo_list!(todo_list.id) end
    end

    test "change_todo_list/1 returns a todo_list changeset" do
      todo_list = todo_list_fixture()
      assert %Ecto.Changeset{} = Focus.change_todo_list(todo_list)
    end
  end
end
