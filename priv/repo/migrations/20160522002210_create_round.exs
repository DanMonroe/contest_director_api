defmodule ContestDirectorApi.Repo.Migrations.CreateRound do
  use Ecto.Migration

  def change do
    create table(:rounds) do
      add :name, :string
      add :order, :integer
      add :numjudges, :integer
      add :drophigh, :integer
      add :droplow, :integer
      add :contest_id, references(:contests, on_delete: :nothing)
      add :pilotclass_id, references(:pilotclasses, on_delete: :nothing)
      add :maneuverset_id, references(:maneuversets, on_delete: :nothing)

      timestamps
    end
    create index(:rounds, [:contest_id])
    create index(:rounds, [:pilotclass_id])
    create index(:rounds, [:maneuverset_id])

  end
end
