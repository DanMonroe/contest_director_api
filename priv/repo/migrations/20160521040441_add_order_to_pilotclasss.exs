defmodule ContestDirectorApi.Repo.Migrations.AddOrderToPilotclasss do
  use Ecto.Migration

  def change do
    alter table(:pilotclasses) do
      add :order, :integer
    end
  end
end
