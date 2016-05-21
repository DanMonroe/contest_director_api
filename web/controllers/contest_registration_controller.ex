defmodule ContestDirectorApi.ContestRegistrationController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.ContestRegistration
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    contestregistrations = Repo.all(ContestRegistration)
    render(conn, "index.json", data: contestregistrations)
  end

  def create(conn, %{"data" => data = %{"type" => "contest_registrations",
    "attributes" => _contest_registration_params,
    "relationships" => relationship_params}}) do

    changeset = ContestRegistration.changeset(%ContestRegistration{
      contest_id: String.to_integer(relationship_params["contest"]["data"]["id"]),
      pilotclass_id: String.to_integer(relationship_params["pilotclass"]["data"]["id"]),
      pilot_id: String.to_integer(relationship_params["pilot"]["data"]["id"])
      }, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, contest_registration} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", contest_registration_path(conn, :show, contest_registration))
        |> render("show.json", data: contest_registration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contest_registration = Repo.get!(ContestRegistration, id)
    render(conn, "show.json", data: contest_registration)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "contest_registrations", "attributes" => _contest_registration_params}}) do
    contest_registration = Repo.get!(ContestRegistration, id)
    changeset = ContestRegistration.changeset(contest_registration, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, contest_registration} ->
        render(conn, "show.json", data: contest_registration)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contest_registration = Repo.get!(ContestRegistration, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(contest_registration)

    send_resp(conn, :no_content, "")
  end

end
