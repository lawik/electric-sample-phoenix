defmodule Admin.Focus.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :string, autogenerate: false}
  @foreign_key_type :string
  schema "todo" do
    field :completed, :integer
    field :listid, :string
    field :text, :string

    #timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:listid, :text, :completed])
    |> validate_required([:listid, :text, :completed])
  end
end
