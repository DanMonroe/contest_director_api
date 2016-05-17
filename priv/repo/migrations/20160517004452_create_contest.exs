defmodule ContestDirectorApi.Repo.Migrations.CreateContest do
  use Ecto.Migration

  def change do
    create table(:contests) do
      add :name, :string
      add :slug, :string
      add :aircrafttype_id, :integer

      timestamps
    end

  end
end
