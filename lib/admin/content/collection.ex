defmodule Admin.Content.Collection do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:slug, :string, autogenerate: false}
  schema "collections" do
    field :name, :string
  end

  @doc false
  def changeset(collection, attrs) do
    collection
    |> cast(attrs, [:slug, :name])
    |> validate_required([:slug, :name])
  end
end
