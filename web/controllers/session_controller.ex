defmodule ContestDirectorApi.SessionController do
  use ContestDirectorApi.Web, :controller

  def index(conn, _params) do
    # Return some static JSON for now
    conn
    |> json(%{status: "Ok!!"})
  end
end