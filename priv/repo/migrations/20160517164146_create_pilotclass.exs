defmodule ContestDirectorApi.Repo.Migrations.CreatePilotclass do
  use Ecto.Migration

  def change do
    create table(:pilotclasses) do
      add :name, :string
      add :aircrafttype_id, references(:aircrafttypes, on_delete: :nothing)

      timestamps
    end
    create index(:pilotclasses, [:aircrafttype_id])

  end
end
