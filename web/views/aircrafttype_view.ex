defmodule ContestDirectorApi.AircrafttypeView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :inserted_at, :updated_at]
  

end
