defmodule ContestDirectorApi.ContestView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:name, :slug, :aircrafttype_id, :inserted_at, :updated_at]
  

end
