defmodule ContestDirectorApi.AircrafttypeView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name]

  # def render("index.json", %{aircrafttypes: aircrafttypes}) do
  #   %{aircrafttypes: render_many(aircrafttypes, ContestDirectorApi.AircrafttypeView, "aircrafttype.json")}
  # end

  # def render("show.json", %{aircrafttype: aircrafttype}) do
  #   %{aircrafttype: render_one(aircrafttype, ContestDirectorApi.AircrafttypeView, "aircrafttype.json")}
  # end

  # def render("aircrafttype.json", %{aircrafttype: aircrafttype}) do
  #   %{id: aircrafttype.id,
  #     name: aircrafttype.name}
  # end
end
