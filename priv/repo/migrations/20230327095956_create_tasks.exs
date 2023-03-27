defmodule TodoApp.Repo.Migrations.CreateTasks do
  use Ecto.Migration

  def change do
    create table(:tasks, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :is_locked, :boolean, default: false, null: false
      add :is_completed, :boolean, default: false, null: false
      add :depends_on, {:array, :uuid}, default: []

      add :task_group_id, references(:task_groups, type: :uuid, on_delete: :delete_all)

      timestamps()
    end

    create index(:tasks, [:task_group_id])
  end
end
