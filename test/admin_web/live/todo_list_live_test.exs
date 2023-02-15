defmodule AdminWeb.TodoListLiveTest do
  use AdminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Admin.FocusFixtures

  @create_attrs %{editing: "some editing", filter: "some filter"}
  @update_attrs %{editing: "some updated editing", filter: "some updated filter"}
  @invalid_attrs %{editing: nil, filter: nil}

  defp create_todo_list(_) do
    todo_list = todo_list_fixture()
    %{todo_list: todo_list}
  end

  describe "Index" do
    setup [:create_todo_list]

    test "lists all todolist", %{conn: conn, todo_list: todo_list} do
      {:ok, _index_live, html} = live(conn, ~p"/todolist")

      assert html =~ "Listing Todolist"
      assert html =~ todo_list.editing
    end

    test "saves new todo_list", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/todolist")

      assert index_live |> element("a", "New Todo list") |> render_click() =~
               "New Todo list"

      assert_patch(index_live, ~p"/todolist/new")

      assert index_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#todo_list-form", todo_list: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/todolist")

      assert html =~ "Todo list created successfully"
      assert html =~ "some editing"
    end

    test "updates todo_list in listing", %{conn: conn, todo_list: todo_list} do
      {:ok, index_live, _html} = live(conn, ~p"/todolist")

      assert index_live |> element("#todolist-#{todo_list.id} a", "Edit") |> render_click() =~
               "Edit Todo list"

      assert_patch(index_live, ~p"/todolist/#{todo_list}/edit")

      assert index_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#todo_list-form", todo_list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/todolist")

      assert html =~ "Todo list updated successfully"
      assert html =~ "some updated editing"
    end

    test "deletes todo_list in listing", %{conn: conn, todo_list: todo_list} do
      {:ok, index_live, _html} = live(conn, ~p"/todolist")

      assert index_live |> element("#todolist-#{todo_list.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todo_list-#{todo_list.id}")
    end
  end

  describe "Show" do
    setup [:create_todo_list]

    test "displays todo_list", %{conn: conn, todo_list: todo_list} do
      {:ok, _show_live, html} = live(conn, ~p"/todolist/#{todo_list}")

      assert html =~ "Show Todo list"
      assert html =~ todo_list.editing
    end

    test "updates todo_list within modal", %{conn: conn, todo_list: todo_list} do
      {:ok, show_live, _html} = live(conn, ~p"/todolist/#{todo_list}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Todo list"

      assert_patch(show_live, ~p"/todolist/#{todo_list}/show/edit")

      assert show_live
             |> form("#todo_list-form", todo_list: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#todo_list-form", todo_list: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/todolist/#{todo_list}")

      assert html =~ "Todo list updated successfully"
      assert html =~ "some updated editing"
    end
  end
end
