use Mix.Config

# In this file, we keep production configuration that
# you likely want to automate and keep it away from
# your version control system.
config :peepchat, ContestDirectorApi.Endpoint,
  secret_key_base: System.get_env("SECRET_KEY_BASE")

# Configure your database
config :peepchat, ContestDirectorApi.Repo,
  adapter: Ecto.Adapters.Postgres,
  username: System.get_env("DATABASE_USERNAME"),
  password: System.get_env("DATABASE_PASSWORD"),
  database: "contest_director_api_prod",
  pool_size: 20
