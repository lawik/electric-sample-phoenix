defmodule Admin.FocusFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Admin.Focus` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        completed: 42,
        listid: "some listid",
        text: "some text"
      })
      |> Admin.Focus.create_todo()

    todo
  end

  @doc """
  Generate a todo_list.
  """
  def todo_list_fixture(attrs \\ %{}) do
    {:ok, todo_list} =
      attrs
      |> Enum.into(%{
        editing: "some editing",
        filter: "some filter"
      })
      |> Admin.Focus.create_todo_list()

    todo_list
  end
end
