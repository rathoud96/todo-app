# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     TodoApp.Repo.insert!(%TodoApp.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias TodoApp.Repo
alias TodoApp.Schema.{Task, TaskGroup}

task_group1 = Repo.insert!(TaskGroup.changeset(%TaskGroup{}, %{name: "Task Group1"}))
task_group2 = Repo.insert!(TaskGroup.changeset(%TaskGroup{}, %{name: "Task Group2"}))

task1_gp1 = Repo.insert!(Task.changeset(task_group1, %{name: "Read Docs"}))
task2_gp1 = Repo.insert!(Task.changeset(task_group1, %{name: "Complete Project"}))

Repo.insert!(Task.changeset(task_group1, %{name: "Locked Task", depends_on: [task1_gp1.id]}))
Repo.insert!(Task.changeset(task_group2, %{name: "Find new anime"}))
Repo.insert!(Task.changeset(task_group2, %{name: "Finish new anime"}))
