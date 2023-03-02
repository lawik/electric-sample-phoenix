defmodule Admin.Repo.Watcher do
  use GenServer

  require Logger
  alias Admin.Repo.Utils

  def start_link(opts) do
    GenServer.start_link(Admin.Repo.Watcher, opts, name: Admin.Repo.Watcher)
  end

  def init(_opts) do
    Utils.subscribe(self())
    {:ok, nil}
  end

  def handle_info(msg, state) do
    msg
    |> Utils.process_msg()
    |> Enum.uniq()
    |> Enum.each(fn type ->
      Logger.info("Broadcasting change for type '#{type}'.")
      Phoenix.PubSub.local_broadcast(Admin.PubSub, "changes:#{type}", :updated)
    end)
    {:noreply, state}
  end
end
