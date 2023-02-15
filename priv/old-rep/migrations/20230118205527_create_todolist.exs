defmodule Admin.Repo.Migrations.CreateTodolist do
  use Ecto.Migration

  def change do
    create table(:todolist, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :filter, :text
      add :editing, :text

      timestamps()
    end
  end
end
