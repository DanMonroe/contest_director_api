defmodule ContestDirectorApi.ManeuverView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :order, :minscore, :maxscore, :kfactor, :inserted_at, :updated_at]
  
  has_one :maneuverset,
    field: :maneuverset_id,
    type: "maneuverset"

end
