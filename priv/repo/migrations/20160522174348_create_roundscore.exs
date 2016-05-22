defmodule ContestDirectorApi.Repo.Migrations.CreateRoundscore do
  use Ecto.Migration

  def change do
    create table(:roundscores) do
      add :totalroundscore, :float
      add :normalizedscore, :float
      add :contestregistration_id, references(:contestregistrations, on_delete: :nothing)
      add :round_id, references(:rounds, on_delete: :nothing)

      timestamps
    end
    create index(:roundscores, [:contestregistration_id])
    create index(:roundscores, [:round_id])

  end
end
