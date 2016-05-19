defmodule ContestDirectorApi.PilotclassView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]

  has_one :aircrafttype,
    field: :aircrafttype_id,
    type: "aircrafttype"

  has_many :maneuversets
end
