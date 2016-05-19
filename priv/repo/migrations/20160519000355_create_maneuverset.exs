defmodule ContestDirectorApi.Repo.Migrations.CreateManeuverset do
  use Ecto.Migration

  def change do
    create table(:maneuversets) do
      add :name, :string
      add :pilotclass_id, references(:pilotclasses, on_delete: :nothing)

      timestamps
    end
    create index(:maneuversets, [:pilotclass_id])

  end
end
