defmodule ContestDirectorApi.Repo.Migrations.CreatePilot do
  use Ecto.Migration

  def change do
    create table(:pilots) do
      add :firstname, :string
      add :lastname, :string
      add :email, :string
      add :phone, :string
      add :amanumber, :string

      timestamps
    end

  end
end
