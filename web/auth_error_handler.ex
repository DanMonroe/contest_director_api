defmodule ContestDirectorApi.AuthErrorHandler do
 use ContestDirectorApi.Web, :controller

 def unauthenticated(conn, params) do
  conn
   |> put_status(401)
   |> render(ContestDirectorApi.ErrorView, "401.json")
 end

 def unauthorized(conn, params) do
  conn
   |> put_status(403)
   |> render(ContestDirectorApi.ErrorView, "403.json")
 end
end