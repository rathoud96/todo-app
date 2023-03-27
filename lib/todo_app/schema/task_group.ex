defmodule TodoApp.Schema.TaskGroup do
  @moduledoc """
  Schema for TaskGroup
  """
  use TodoApp.Schema
  import Ecto.Changeset

  schema "task_groups" do
    field :name, :string

    has_many :tasks, TodoApp.Schema.Task

    timestamps()
  end

  @spec changeset(Ecto.Schema.t, map | :invalid) :: Changeset.t
  def changeset(task_group, attrs) do
    task_group
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
