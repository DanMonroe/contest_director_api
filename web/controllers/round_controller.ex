defmodule ContestDirectorApi.RoundController do
  use ContestDirectorApi.Web, :controller
  import Ecto.Query, only: [from: 2]

  require Logger

  alias ContestDirectorApi.Round
  alias ContestDirectorApi.Maneuver
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    rounds = Repo.all(Round)
    render(conn, "index.json", data: rounds)
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
