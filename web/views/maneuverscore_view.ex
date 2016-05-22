defmodule ContestDirectorApi.ManeuverscoreView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:totalscore, :inserted_at, :updated_at]

  has_one :maneuver,
    field: :maneuver_id,
    type: "maneuver"
  has_one :roundscore,
    field: :roundscore_id,
    type: "roundscore"

    has_many :scores
end
