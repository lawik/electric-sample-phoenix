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
      # Start the PubSub system
      {Phoenix.PubSub, name: Admin.PubSub},
      # Start Finch
      {Finch, name: Admin.Finch},
      # Start the repo supervisor
      Admin.Repo.Supervisor,
      # Start the Endpoint (http/https)
      AdminWeb.Endpoint

      # Start a worker by calling: Admin.Worker.start_link(arg)
      # {Admin.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Admin.Supervisor]
    {:ok, result} = Supervisor.start_link(children, opts)

    Task.start(fn ->
      # Attempt to create publication, fails if already done :)
      Ecto.Adapters.SQL.query(
        Admin.Repo,
        "CREATE PUBLICATION example_publication FOR ALL TABLES"
      )
    end)

    {:ok, result}
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    AdminWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
