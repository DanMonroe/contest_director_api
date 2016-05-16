defmodule ContestDirectorApi.Repo.Migrations.CreateAircrafttype do
  use Ecto.Migration

  def change do
    create table(:aircrafttypes) do
      add :name, :string

      timestamps
    end

  end
end
