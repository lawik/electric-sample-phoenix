defmodule Admin.ContentTest do
  use Admin.DataCase

  alias Admin.Content

  describe "collections" do
    alias Admin.Content.Collection

    import Admin.ContentFixtures

    @invalid_attrs %{name: nil, slug: nil}

    test "list_collections/0 returns all collections" do
      collection = collection_fixture()
      assert Content.list_collections() == [collection]
    end

    test "get_collection!/1 returns the collection with given id" do
      collection = collection_fixture()
      assert Content.get_collection!(collection.id) == collection
    end

    test "create_collection/1 with valid data creates a collection" do
      valid_attrs = %{name: "some name", slug: "some slug"}

      assert {:ok, %Collection{} = collection} = Content.create_collection(valid_attrs)
      assert collection.name == "some name"
      assert collection.slug == "some slug"
    end

    test "create_collection/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Content.create_collection(@invalid_attrs)
    end

    test "update_collection/2 with valid data updates the collection" do
      collection = collection_fixture()
      update_attrs = %{name: "some updated name", slug: "some updated slug"}

      assert {:ok, %Collection{} = collection} = Content.update_collection(collection, update_attrs)
      assert collection.name == "some updated name"
      assert collection.slug == "some updated slug"
    end

    test "update_collection/2 with invalid data returns error changeset" do
      collection = collection_fixture()
      assert {:error, %Ecto.Changeset{}} = Content.update_collection(collection, @invalid_attrs)
      assert collection == Content.get_collection!(collection.id)
    end

    test "delete_collection/1 deletes the collection" do
      collection = collection_fixture()
      assert {:ok, %Collection{}} = Content.delete_collection(collection)
      assert_raise Ecto.NoResultsError, fn -> Content.get_collection!(collection.id) end
    end

    test "change_collection/1 returns a collection changeset" do
      collection = collection_fixture()
      assert %Ecto.Changeset{} = Content.change_collection(collection)
    end
  end
end
