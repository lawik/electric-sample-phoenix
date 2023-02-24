defmodule Admin.Repo do
  case System.fetch_env!("DB") do
    "postgres" ->
      use Ecto.Repo,
        otp_app: :admin,
        adapter: Ecto.Adapters.Postgres
    "sqlite" ->
      use Ecto.Repo,
        otp_app: :admin,
        adapter: Ecto.Adapters.SQLite3
  end
end
