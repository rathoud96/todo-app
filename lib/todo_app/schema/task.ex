defmodule TodoApp.Schema.Task do
  @moduledoc """
  Schema for Task
  """
  use TodoApp.Schema
  import Ecto.Changeset

  alias TodoApp.Schema.TaskGroup

  schema "tasks" do
    field :is_completed, :boolean, default: false
    field :is_locked, :boolean, default: false
    field :name, :string
    field :depends_on, {:array, :binary_id}, default: []

    belongs_to :task_group, TaskGroup,
      foreign_key: :task_group_id,
      references: :id,
      type: :binary_id

    timestamps()
  end

  @params [:name, :is_locked, :is_completed, :depends_on]

  @spec changeset(Ecto.Schema.t, map | :invalid) :: Changeset.t
  def changeset(task_group, attrs) do
    task_group
    |> Ecto.build_assoc(:tasks)
    |> cast(attrs, @params)
    |> validate_required([:name])
    |> validate_depends_on()
  end

  @spec changeset(Ecto.Schema.t, map | :invalid) :: Changeset.t
  def update_changeset(task, attrs) do
    task
    |> cast(attrs, @params)
  end

  defp validate_depends_on(changeset) do
    depends_on = Map.get(changeset.changes, :depends_on)

    cond do
      is_nil(depends_on) ->
        changeset

      depends_on == [] ->
        changeset

      true ->
        put_change(changeset, :is_locked, true)
    end
  end
end
