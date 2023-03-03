defmodule AdminWeb.CollectionLiveTest do
  use AdminWeb.ConnCase

  import Phoenix.LiveViewTest
  import Admin.ContentFixtures

  @create_attrs %{name: "some name", slug: "some slug"}
  @update_attrs %{name: "some updated name", slug: "some updated slug"}
  @invalid_attrs %{name: nil, slug: nil}

  defp create_collection(_) do
    collection = collection_fixture()
    %{collection: collection}
  end

  describe "Index" do
    setup [:create_collection]

    test "lists all collections", %{conn: conn, collection: collection} do
      {:ok, _index_live, html} = live(conn, ~p"/collections")

      assert html =~ "Listing Collections"
      assert html =~ collection.name
    end

    test "saves new collection", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/collections")

      assert index_live |> element("a", "New Collection") |> render_click() =~
               "New Collection"

      assert_patch(index_live, ~p"/collections/new")

      assert index_live
             |> form("#collection-form", collection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#collection-form", collection: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/collections")

      assert html =~ "Collection created successfully"
      assert html =~ "some name"
    end

    test "updates collection in listing", %{conn: conn, collection: collection} do
      {:ok, index_live, _html} = live(conn, ~p"/collections")

      assert index_live |> element("#collections-#{collection.id} a", "Edit") |> render_click() =~
               "Edit Collection"

      assert_patch(index_live, ~p"/collections/#{collection}/edit")

      assert index_live
             |> form("#collection-form", collection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#collection-form", collection: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/collections")

      assert html =~ "Collection updated successfully"
      assert html =~ "some updated name"
    end

    test "deletes collection in listing", %{conn: conn, collection: collection} do
      {:ok, index_live, _html} = live(conn, ~p"/collections")

      assert index_live |> element("#collections-#{collection.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#collection-#{collection.id}")
    end
  end

  describe "Show" do
    setup [:create_collection]

    test "displays collection", %{conn: conn, collection: collection} do
      {:ok, _show_live, html} = live(conn, ~p"/collections/#{collection}")

      assert html =~ "Show Collection"
      assert html =~ collection.name
    end

    test "updates collection within modal", %{conn: conn, collection: collection} do
      {:ok, show_live, _html} = live(conn, ~p"/collections/#{collection}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Collection"

      assert_patch(show_live, ~p"/collections/#{collection}/show/edit")

      assert show_live
             |> form("#collection-form", collection: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#collection-form", collection: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, ~p"/collections/#{collection}")

      assert html =~ "Collection updated successfully"
      assert html =~ "some updated name"
    end
  end
end
