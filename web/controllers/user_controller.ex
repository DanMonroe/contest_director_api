defmodule ContestDirectorApi.UserController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.User
  plug Guardian.Plug.EnsureAuthenticated, handler: ContestDirectorApi.AuthErrorHandler

  def current(conn, _) do
    user = conn
    |> Guardian.Plug.current_resource

    conn
    |> render(ContestDirectorApi.UserView, "show.json", user: user)
  end
end