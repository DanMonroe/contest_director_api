defmodule ContestDirectorApi.Router do
  use ContestDirectorApi.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  scope "/api", ContestDirectorApi do
    pipe_through :api

    # Route stuff to our SessionController
    resources "session", SessionController, only: [:index]
  end
end
