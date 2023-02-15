defmodule Admin.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :listid, :text
      add :text, :text
      add :completed, :integer

      timestamps()
    end
  end
end
