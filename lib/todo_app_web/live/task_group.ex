defmodule TodoAppWeb.Live.TaskGroup do
  use TodoAppWeb, :live_view

  alias TodoApp.Todo
  def mount(params, _session, socket) do
    task_group = params["id"] |> Todo.get_task_group_by_id!()
    {:ok, assign(socket, :task_group, task_group)}
  end

  defp is_locked(dependent_task_ids) when dependent_task_ids == [] do
    false
  end

  defp is_locked(dependent_task_ids) when is_list(dependent_task_ids) do
    result =
      dependent_task_ids
      |> Enum.filter(fn task_id ->
        Todo.get_task_by_id!(task_id).is_completed
      end)

    if result == [] do
      true
    else
      false
    end
  end

  defp has_dependent_tasks(dependent_task_ids) do
    if dependent_task_ids != [] do
      true
    else
      false
    end
  end

  defp completed(%{is_completed: true, is_locked: false}) do
    "line-through"
  end

  defp completed(%{is_completed: false, is_locked: false}) do
    ""
  end

  defp completed(%{is_completed: false, is_locked: true}) do
    ""
  end

  defp toggle_button_class(%{is_completed: true}) do
    "bg-lime-300"
  end

  defp toggle_button_class(%{is_completed: false}) do
    ""
  end

  def handle_event("toggle", params, socket) do
    task =
      params["id"]
      |> Todo.get_task_by_id!()

    if not is_locked(task.depends_on) do
      task |> Todo.update_task(%{is_completed: !task.is_completed, is_locked: false})
    else
      task |> Todo.update_task(%{is_completed: false, is_locked: true})
    end

    {:noreply, assign(socket, task_group: Todo.get_task_group_by_id!(socket.assigns.task_group.id))}
  end

  def render(assigns) do
    ~H"""
    <div class="container border-box border-1">
      <div class="items-center sm:flex space-x-96">
      <h1 class="text-slate-500 text-3xl"><%= @task_group.name %></h1>
      <.link class="text-sky-600 text-sm font-medium justify-end" navigate={~p"/"}>ALL GROUPS</.link>
      </div>
      <hr class="my-8 h-0.5 border-t-0 bg-slate-100" />
      <%= for task <- @task_group.tasks do %>
        <ul class="items-center w-full text-sm font-medium bg-white sm:flex">
          <li class="w-full">
            <div class="flex items-center pl-3">
              <%= if is_locked(task.depends_on) && has_dependent_tasks(task.depends_on) do %>
                <button>
                  <img class="block w-6 h-6 w-auto rounded" src="/images/lock.png" alt="locked" />
                </button>
              <% else %>
                <div class="box-border p-0.5 h-6 w-6 border-2">
                  <button phx-click="toggle" phx-value-id={task.id} class={["h-4 w-4 box-border", toggle_button_class(task)]}>
                  </button>
                </div>
              <% end %>
              <h2 class={["px-11 text-xl", completed(task)]}><%= task.name %></h2>
            </div>
            <hr class="my-8 h-0.5 border-t-0 bg-slate-100" />
          </li>
        </ul>
      <% end %>
    </div>
    """
  end
end
