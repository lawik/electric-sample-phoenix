defmodule Admin.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      AdminWeb.Telemetry,
      # Start the Ecto repository
      Admin.Repo,
      # Start the PubSub system
      {Phoenix.PubSub, name: Admin.PubSub},
      # Start Finch
      {Finch, name: Admin.Finch},
      # Start the Endpoint (http/https)
      {
        Cainophile.Adapters.Postgres,
        # name this process will be registered globally as, for usage with Cainophile.Adapters.Postgres.subscribe/2
        # All epgsql options are supported here
        # :temporary is also supported if you don't want Postgres keeping track of what you've acknowledged
        # You can provide a different WAL position if desired, or default to allowing Postgres to send you what it thinks you need
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
      },
      AdminWeb.Endpoint

      # Start a worker by calling: Admin.Worker.start_link(arg)
      # {Admin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Admin.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
