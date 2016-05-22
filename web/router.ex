defmodule ContestDirectorApi.Router do
  use ContestDirectorApi.Web, :router

  pipeline :api do
    plug :accepts, ["json", "json-api"]
    # plug JaSerializer.ContentTypeNegotiation
    # plug JaSerializer.Deserializer
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

    resources "/aircrafttypes", AircrafttypeController, except: [:new, :edit] do
      get "pilotclasses", PilotclassController, :index, as: :pilotclasses
    end
    resources "/contests", ContestController, except: [:new, :edit] do
      get "contestregistrations", ContestregistrationController, :index, as: :contestregistrations
      get "rounds", RoundController, :index, as: :rounds
    end
    resources "/pilots", PilotController, except: [:new, :edit]
    resources "/pilotclasses", PilotclassController, except: [:new, :edit] do
      get "maneuversets", ManeuversetController, :index, as: :maneuversets
    end
    resources "/maneuversets", ManeuversetController, except: [:new, :edit] do
      get "maneuvers", ManeuversController, :index, as: :maneuvers
    end

    resources "/maneuvers", ManeuverController, except: [:new, :edit]

    resources "/contestregistrations", ContestregistrationController, except: [:new, :edit] do
      get "roundscores", RoundscoreController, :index, as: :roundscores
    end
    resources "/rounds", RoundController, except: [:new, :edit] do
      get "roundscores", RoundscoreController, :index, as: :roundscores
    end
    resources "/roundscores", RoundscoreController, except: [:new, :edit] do
      get "maneuverscores", ManeuverscoreController, :index, as: :maneuverscores
    end
    resources "/maneuverscores", ManeuverscoreController, except: [:new, :edit] do
      get "scores", ScoreController, :index, as: :scores
    end
    resources "/scores", ScoreController, except: [:new, :edit]
  end

  scope "/api", ContestDirectorApi do
    pipe_through :api_auth
    get "/user/current", UserController, :current, as: :current_user
  end
end
