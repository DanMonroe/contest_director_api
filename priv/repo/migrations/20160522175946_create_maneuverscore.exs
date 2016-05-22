defmodule ContestDirectorApi.Repo.Migrations.CreateManeuverscore do
  use Ecto.Migration

  def change do
    create table(:maneuverscores) do
      add :totalscore, :float
      add :maneuver_id, references(:maneuvers, on_delete: :nothing)
      add :roundscore_id, references(:roundscores, on_delete: :nothing)

      timestamps
    end
    create index(:maneuverscores, [:maneuver_id])
    create index(:maneuverscores, [:roundscore_id])

  end
end
