defmodule ContestDirectorApi.RoundscoreController do
  use ContestDirectorApi.Web, :controller

  require Logger

  alias ContestDirectorApi.Roundscore
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def find_roundscores_by_contestregistration(contestregistration_id) do
    # query = from rs in Roundscore,
    #   where: rs.contestregistration_id == ^contestregistration_id,
    #   select: rs
    # Repo.all(query)
    Repo.get!(Roundscore, contestregistration_id)
  end

  def index(conn, params) do
    contestregistrationId = params["filter"]["contestregistrationId"]
    roundId = params["filter"]["roundId"]
    if params["filter"]["contestregistrationId"] do
      query = from rndScore in Roundscore,
        where: rndScore.contestregistration_id == ^contestregistrationId and rndScore.round_id == ^roundId,
        select: rndScore

      roundscores = Repo.all(query)
    else
      roundscores = Repo.all(Roundscore)
    end

    render(conn, "index.json", data: roundscores)
  end

#   def index(conn, %{"contestregistrationId" => contestregistrationId, "roundId" => roundId}) do
# Logger.error("In extended index")
#     query = from rndScore in Roundscore,
#       where: rndScore.contestregistration_id == ^contestregistrationId and rndScore.round_id == ^roundId,
#       select: rndScore
#
#     roundscores = Repo.all(query)
#     render(conn, "index.json", data: roundscores)
#   end
#
  def create(conn, %{"data" => data = %{"type" => "roundscores", "attributes" => _roundscore_params}}) do
    changeset = Roundscore.changeset(%Roundscore{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, roundscore} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", roundscore_path(conn, :show, roundscore))
        |> render("show.json", data: roundscore)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    roundscore = Repo.get!(Roundscore, id)
    render(conn, "show.json", data: roundscore)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "roundscores", "attributes" => _roundscore_params}}) do
    roundscore = Repo.get!(Roundscore, id)
    changeset = Roundscore.changeset(roundscore, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, roundscore} ->
        render(conn, "show.json", data: roundscore)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    roundscore = Repo.get!(Roundscore, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(roundscore)

    send_resp(conn, :no_content, "")
  end

end
