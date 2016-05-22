defmodule ContestDirectorApi.Repo.Migrations.CreateScore do
  use Ecto.Migration

  def change do
    create table(:scores) do
      add :points, :float
      add :maneuverscore_id, references(:maneuverscores, on_delete: :nothing)

      timestamps
    end
    create index(:scores, [:maneuverscore_id])

  end
end
