defmodule ContestDirectorApi.RoundController do
  use ContestDirectorApi.Web, :controller
  # import Ecto.Query, only: [from: 2]

  require Logger

  alias ContestDirectorApi.Round
  # alias ContestDirectorApi.Maneuver
  alias ContestDirectorApi.ContestController
  alias ContestDirectorApi.ManeuversetController
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    rounds = Repo.all(Round)
    render(conn, "index.json", data: rounds)
  end

  def create_scores_from_round(newRound) do

    contest = ContestController.get_contest_by_id newRound.contest_id

    # maneuverset = ManeuversetController.get_maneuverset_by_id newRound.maneuverset_id

    maneuvers = ContestDirectorApi.ManeuverController.find_maneuvers_by_maneuverset_id newRound.maneuverset_id

    # Logger.warn("Maneuvers found: " <> to_string(Enum.count(maneuvers)))

    # Logger.warn("searching for registrations")

    registrations = ContestDirectorApi.ContestregistrationController.find_contestregistrations_by_contest_and_pilotclass(contest.id, newRound.pilotclass_id)

    # Logger.warn("Registrations found: " <> to_string(Enum.count(registrations)))

    # Logger.warn("Looping through registrations")
    Enum.each(registrations, fn(registration) ->
      # Logger.warn("This registration for " <> registration.pilotname)
      # Logger.error("Creating new roundscore")
      rndscore = Repo.insert! %ContestDirectorApi.Roundscore{contestregistration: registration, round: newRound, totalroundscore: 0.0}

      # Logger.warn("     pilot: " <> rndscore.contestregistration.pilotname)
      # Logger.warn("     totalscore: " <> to_string(rndscore.totalroundscore))
      # Logger.warn("     round name: " <> rndscore.round.name)

      # Logger.warn("   Looping through maneuvers")
      Enum.each(maneuvers, fn(thismaneuver) ->
      # Logger.warn("     this maneuver name: " <> thismaneuver.name)
      # Logger.warn("       Creating new maneuver score")
        manscore = Repo.insert! %ContestDirectorApi.Maneuverscore{
          maneuver: thismaneuver,
          roundscore: rndscore,
          totalscore: 0.0}
      # Logger.warn("         Creating new scores for " <> manscore.maneuver.name)
        Enum.each 1..newRound.numjudges, fn(_) ->
          Repo.insert! %ContestDirectorApi.Score{
            points: 0.0,
            maneuverscore: manscore
          }
      # Logger.warn("           score points: " <> to_string(newscore.points))
        end
      end)
    end)
  end

  def create(conn, %{"data" => data = %{"type" => "rounds",
    "attributes" => _maneuverset_params,
    "relationships" => relationship_params}}) do

    changeset = Round.changeset(%Round{
      contest_id: String.to_integer(relationship_params["contest"]["data"]["id"]),
      pilotclass_id: String.to_integer(relationship_params["pilotclass"]["data"]["id"]),
      maneuverset_id: String.to_integer(relationship_params["maneuverset"]["data"]["id"])
      }, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, round} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", round_path(conn, :show, round))
        |> render("show.json", data: round)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)
    render(conn, "show.json", data: round)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "rounds", "attributes" => _round_params}}) do
    round = Repo.get!(Round, id)
    changeset = Round.changeset(round, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, round} ->
        render(conn, "show.json", data: round)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    round = Repo.get!(Round, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(round)

    send_resp(conn, :no_content, "")
  end

end
