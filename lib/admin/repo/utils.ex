defmodule Admin.Repo.Utils do
  require Logger
  case System.fetch_env!("DB") do
    "postgres" ->
      def children do
        # TODO: remove hard-coded creds and do something smart instead
        [
          { Cainophile.Adapters.Postgres,
            register: Cainophile.ExamplePublisher,
            epgsql: %{
              host: 'localhost',
              #    host: 'default.pinnate-aquarius-9466.db.electric-sql.com',
              username: "electric",
              database: "electric",
              password: "password",
              port: 54323,
              #    port: 5432,
              ssl: false
            },
            slot: :temporary,
            wal_position: {"0", "0"},
            publications: ["example_publication"]
          }
        ]
        end

      def subscribe(pid) do
        Cainophile.Adapters.Postgres.subscribe(Cainophile.ExamplePublisher, pid)
        :ok
      end

      def process_msg(%Cainophile.Changes.Transaction{changes: changes} = tx) do
        changes
        |> Enum.map(fn ch ->
          case ch do
            %{relation: {_, table}} ->
              table
            _ ->
              Logger.debug("Ignored msg: #{inspect(changes)}")
              nil
          end
        end)
        |> Enum.reject(&is_nil/1)
      end

    "sqlite" ->
      def children do
        config_path = Path.expand("~/projects/electric/sidecar/.electric/pinnate-aquarius-9466/default/index.js")
        [
          {ElectricSidecar, path: "/tmp/database.db", config_path: config_path, pid: Admin.Repo.Watcher}
        ]
      end

      def subscribe(_) do
        :ok
      end

      def process_msg(change) do
        case change do
          {:change, json} ->
            case Jason.decode!(json) do
              %{"event" => "data_changed", "change" => %{"changes" => changes }} ->
                changes
                |> Enum.map(fn change ->
                  case change do
                    %{"qualifiedTablename" => %{"tablename" => table}} ->
                      table
                    _ ->
                      Logger.debug("Ignored change: #{inspect(change)}")
                      nil
                  end
                end)
                |> Enum.reject(&is_nil/1)
              _ ->
                Logger.debug("Ignored changes: #{inspect(json)}")
                []
            end
          _ ->
            Logger.debug("Ignored msg: #{inspect(change)}")
            []
        end
      end
  end
end
