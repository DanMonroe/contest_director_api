defmodule ContestDirectorApi.ManeuversetView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]

  has_one :pilotclass,
    field: :pilotclass_id,
    type: "pilotclass"

    has_many :maneuvers
end
