defmodule ContestDirectorApi.RoundView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :order, :numjudges, :drophigh, :droplow, :inserted_at, :updated_at]
  
  has_one :contest,
    field: :contest_id,
    type: "contest"
  has_one :pilotclass,
    field: :pilotclass_id,
    type: "pilotclass"
  has_one :maneuverset,
    field: :maneuverset_id,
    type: "maneuverset"

end
