defmodule ContestDirectorApi.Repo.Migrations.CreateManeuver do
  use Ecto.Migration

  def change do
    create table(:maneuvers) do
      add :name, :string
      add :order, :integer
      add :minscore, :float
      add :maxscore, :float
      add :kfactor, :float
      add :maneuverset_id, references(:maneuversets, on_delete: :nothing)

      timestamps
    end
    create index(:maneuvers, [:maneuverset_id])

  end
end
