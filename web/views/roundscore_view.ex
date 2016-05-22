defmodule ContestDirectorApi.RoundscoreView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:totalroundscore, :normalizedscore, :inserted_at, :updated_at]

  has_one :contestregistration,
    field: :contestregistration_id,
    type: "contestregistration"
  has_one :round,
    field: :round_id,
    type: "round"

    has_many :maneuverscores
end
