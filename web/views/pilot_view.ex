defmodule ContestDirectorApi.PilotView do
  use ContestDirectorApi.Web, :view
  use JaSerializer.PhoenixView

  attributes [:firstname, :lastname, :email, :phone, :amanumber, :inserted_at, :updated_at]
  

end
