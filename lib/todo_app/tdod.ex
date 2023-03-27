defmodule TodoApp.Todo do
  @moduledoc """
  Contains finction to interact with task_group and task data
  """
  import Ecto.Query

  alias TodoApp.Repo
  alias TodoApp.Schema.{Task, TaskGroup}

  @type uuid() :: String.t()

  def get_all_task_groups do
    Repo.all(TaskGroup) |> Repo.preload(:tasks)
  end

  def get_task_group_by_id!(nil) do
    nil
  end

  @spec get_task_group_by_id!(uuid()) :: %TaskGroup{}
  def get_task_group_by_id!(id) when is_binary(id) do
    Repo.get!(TaskGroup, id) |> Repo.preload([tasks: from(t in Task, order_by: t.name)])
  end

  @spec update_task_group(%TaskGroup{}, map()) :: %TaskGroup{}
  def update_task_group(task_group, params) do
    task_group
    |> TaskGroup.changeset(params)
    |> Repo.update!()
  end

  def get_task_by_id!(nil) do
    nil
  end

  @spec get_task_by_id!(uuid()) :: %Task{}
  def get_task_by_id!(id) when is_binary(id) do
    Repo.get!(Task, id)
  end

  @spec update_task(%Task{}, map()) :: %Task{}
  def update_task(task, params) do
    task
    |> Task.update_changeset(params)
    |> Repo.update!()
  end
end
