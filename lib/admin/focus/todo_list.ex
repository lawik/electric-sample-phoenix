defmodule Admin.Focus.TodoList do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "todolist" do
    field :editing, :string
    field :filter, :string

    timestamps()
  end

  @doc false
  def changeset(todo_list, attrs) do
    todo_list
    |> cast(attrs, [:filter, :editing])
    |> validate_required([:filter, :editing])
  end
end
