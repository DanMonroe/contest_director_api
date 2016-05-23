defmodule ContestDirectorApi.ManeuversetController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Maneuverset
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    maneuversets = Repo.all(Maneuverset)
    render(conn, "index.json", data: maneuversets)
  end

  def get_maneuverset_by_id(id) do
    Repo.get!(Maneuverset, id)
  end

  def create(conn, %{"data" => data = %{"type" => "maneuversets",
    "attributes" => _maneuverset_params,
    "relationships" => relationship_params}}) do
    # changeset = Maneuverset.changeset(%Maneuverset{}, Params.to_attributes(data))

    changeset = Maneuverset.changeset(%Maneuverset{
      pilotclass_id: String.to_integer(relationship_params["pilotclass"]["data"]["id"])
      }, Params.to_attributes(data))



    case Repo.insert(changeset) do
      {:ok, maneuverset} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", maneuverset_path(conn, :show, maneuverset))
        |> render("show.json", data: maneuverset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    maneuverset = Repo.get!(Maneuverset, id)
    render(conn, "show.json", data: maneuverset)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "maneuversets", "attributes" => _maneuverset_params}}) do
    maneuverset = Repo.get!(Maneuverset, id)
    changeset = Maneuverset.changeset(maneuverset, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, maneuverset} ->
        render(conn, "show.json", data: maneuverset)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    maneuverset = Repo.get!(Maneuverset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(maneuverset)

    send_resp(conn, :no_content, "")
  end

end
