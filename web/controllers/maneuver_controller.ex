defmodule ContestDirectorApi.ManeuverController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Maneuver
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    maneuvers = Repo.all(Maneuver)
    render(conn, "index.json", data: maneuvers)
  end

  def create(conn, %{"data" => data = %{"type" => "maneuvers", "attributes" => _maneuver_params, "relationships" => relationship_params}}) do

    changeset = Maneuver.changeset(%Maneuver{
      maneuverset_id: String.to_integer(relationship_params["maneuverset"]["data"]["id"])
      }, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, maneuver} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", maneuver_path(conn, :show, maneuver))
        |> render("show.json", data: maneuver)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    maneuver = Repo.get!(Maneuver, id)
    render(conn, "show.json", data: maneuver)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "maneuvers", "attributes" => _maneuver_params}}) do
    maneuver = Repo.get!(Maneuver, id)
    changeset = Maneuver.changeset(maneuver, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, maneuver} ->
        render(conn, "show.json", data: maneuver)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    maneuver = Repo.get!(Maneuver, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(maneuver)

    send_resp(conn, :no_content, "")
  end

end
