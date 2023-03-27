defmodule TodoApp.Repo.Migrations.CreateTaskGroups do
  use Ecto.Migration

  def change do
    create table(:task_groups, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string

      timestamps()
    end

    create index(:task_groups, [:id])
  end
end
