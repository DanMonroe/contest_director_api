defmodule ContestDirectorApi.ContestregistrationController do
  use ContestDirectorApi.Web, :controller
  require Logger

  alias ContestDirectorApi.Contestregistration
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    contestregistrations = Repo.all(Contestregistration)
    render(conn, "index.json", data: contestregistrations)
  end

  def create(conn, %{"data" => data = %{"type" => "contestregistrations",
    "attributes" => _contest_registration_params,
    "relationships" => relationship_params}}) do

      Logger.debug "here1"

    changeset = Contestregistration.changeset(%Contestregistration{
      contest_id: String.to_integer(relationship_params["contest"]["data"]["id"]),
      pilotclass_id: String.to_integer(relationship_params["pilotclass"]["data"]["id"]),
      pilot_id: String.to_integer(relationship_params["pilot"]["data"]["id"])
      }, Params.to_attributes(data))

      Logger.debug "here2"

    case Repo.insert(changeset) do
      {:ok, contestregistration} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", contestregistration_path(conn, :show, contestregistration))
        |> render("show.json", data: contestregistration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contestregistration = Repo.get!(Contestregistration, id)
    render(conn, "show.json", data: contestregistration)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "contestregistrations", "attributes" => _contestregistration_params}}) do
    contestregistration = Repo.get!(Contestregistration, id)
    changeset = Contestregistration.changeset(contestregistration, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, contestregistration} ->
        render(conn, "show.json", data: contestregistration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contestregistration = Repo.get!(Contestregistration, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(contestregistration)

    send_resp(conn, :no_content, "")
  end

end
