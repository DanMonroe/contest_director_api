defmodule ContestDirectorApi.ScoreView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:points, :inserted_at, :updated_at]
  
  has_one :maneuverscore,
    field: :maneuverscore_id,
    type: "maneuverscore"

end
