defmodule TodoAppWeb.Live.Todos do
  use TodoAppWeb, :live_view

  alias TodoApp.Todo
  def mount(_, _, socket) do
    {:ok, assign(socket, :task_groups, Todo.get_all_task_groups())}
  end

  def complete_task_count(task_group) do
    Enum.filter(task_group.tasks, fn task -> task.is_completed end) |> length()
  end

  def total_tasks(task_group) do
    length(task_group.tasks)
  end

  def render(assigns) do
    ~H"""
    <div class="container box-border border-1">
      <h1 class="text-2xl text-slate-500 font-medium">Things To Do</h1>
      <hr class="my-8 h-0.5 border-t-0 bg-slate-100" />
      <ul class="items-center w-full text-sm font-medium bg-white sm:flex">
        <li class="w-full">
          <%= for task_group <- @task_groups do %>
            <.link class="flex w-4" navigate={~p"/task_group/#{task_group.id}"}><svg class="w-4 h-4" viewBox="0 -0.5 17 17" version="1.1" xmlns="http://www.w3.org/2000/svg" xmlns:xlink="http://www.w3.org/1999/xlink" class="si-glyph si-glyph-triangle-right" fill="#000000" stroke="#000000"><g id="SVGRepo_bgCarrier" stroke-width="0"></g><g id="SVGRepo_tracerCarrier" stroke-linecap="round" stroke-linejoin="round"></g><g id="SVGRepo_iconCarrier"> <title>1234</title> <defs> </defs> <g stroke="none" stroke-width="1" fill="none" fill-rule="evenodd"> <path d="M6.113,15.495 C5.531,16.076 4.01,16.395 4.01,14.494 L4.01,1.506 C4.01,-0.333 5.531,-0.076 6.113,0.506 L12.557,6.948 C13.137,7.529 13.137,8.47 12.557,9.052 L6.113,15.495 L6.113,15.495 Z" fill="#808080" class="si-glyph-fill"> </path> </g> </g></svg></.link>
            <ul class="flex items-center mt-0 ml-16 pl-3">
              <li >
              <h2><%= task_group.name %></h2>
              <p class="text-slate-600"><%= complete_task_count(task_group) %> OF <%= total_tasks(task_group) %> TASKS COMPLETE</p>
              </li>
            </ul>
            <hr class="my-8 h-0.5 border-t-0 bg-slate-100" />
          <% end %>
        </li>
      </ul>
    </div>
    """
  end
end
