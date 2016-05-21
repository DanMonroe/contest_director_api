defmodule ContestDirectorApi.ContestregistrationView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:pilotname, :inserted_at, :updated_at]
  
  has_one :contest,
    field: :contest_id,
    type: "contest"
  has_one :pilotclass,
    field: :pilotclass_id,
    type: "pilotclass"
  has_one :pilot,
    field: :pilot_id,
    type: "pilot"

end
