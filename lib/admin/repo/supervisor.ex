defmodule Admin.Repo.Supervisor do
  use Supervisor
  alias Admin.Repo.Utils

  def start_link(init_arg) do
    Supervisor.start_link(__MODULE__, init_arg, name: __MODULE__)
  end

  @impl true
  def init(_init_arg) do
    kids = Utils.children() ++ [Admin.Repo.Watcher, Admin.Repo]
    Supervisor.init(kids, strategy: :one_for_all)
  end
end
