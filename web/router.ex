defmodule ContestDirectorApi.Router do
  use ContestDirectorApi.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
  end

  # Authenticated Requests
  pipeline :api_auth do
    plug :accepts, ["json", "json-api"]
    plug Guardian.Plug.VerifyHeader, realm: "Bearer"
    plug Guardian.Plug.LoadResource
  end

  scope "/api", ContestDirectorApi do
    pipe_through :api

	  # Registration
    post "register", RegistrationController, :create
    
    # Route stuff to our SessionController
    post "token", SessionController, :create, as: :login
  end

  scope "/api", ContestDirectorApi do
    pipe_through :api_auth
    get "/user/current", UserController, :current, as: :current_user
  end
end
