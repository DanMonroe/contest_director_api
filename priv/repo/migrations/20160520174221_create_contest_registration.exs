defmodule ContestDirectorApi.Repo.Migrations.CreateContestRegistration do
  use Ecto.Migration

  def change do
    create table(:contestregistrations) do
      add :contest_id, references(:contests, on_delete: :nothing)
      add :pilotclass_id, references(:pilotclasses, on_delete: :nothing)
      add :pilot_id, references(:pilots, on_delete: :nothing)

      timestamps
    end
    create index(:contestregistrations, [:contest_id])
    create index(:contestregistrations, [:pilotclass_id])
    create index(:contestregistrations, [:pilot_id])

  end
end
