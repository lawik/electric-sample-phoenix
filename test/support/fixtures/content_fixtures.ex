defmodule Admin.ContentFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admin.Content` context.
  """

  @doc """
  Generate a collection.
  """
  def collection_fixture(attrs \\ %{}) do
    {:ok, collection} =
      attrs
      |> Enum.into(%{
        name: "some name",
        slug: "some slug"
      })
      |> Admin.Content.create_collection()

    collection
  end
end
