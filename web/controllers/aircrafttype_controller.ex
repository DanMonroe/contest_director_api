defmodule ContestDirectorApi.AircrafttypeController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Aircrafttype
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    aircrafttypes = Repo.all(Aircrafttype)
    render(conn, "index.json", data: aircrafttypes)
  end

  def create(conn, %{"data" => data = %{"type" => "aircrafttypes", "attributes" => _aircrafttype_params}}) do
    changeset = Aircrafttype.changeset(%Aircrafttype{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, aircrafttype} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", aircrafttype_path(conn, :show, aircrafttype))
        |> render("show.json", data: aircrafttype)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    aircrafttype = Repo.get!(Aircrafttype, id)
    render(conn, "show.json", data: aircrafttype)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "aircrafttypes", "attributes" => _aircrafttype_params}}) do
    aircrafttype = Repo.get!(Aircrafttype, id)
    changeset = Aircrafttype.changeset(aircrafttype, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, aircrafttype} ->
        render(conn, "show.json", data: aircrafttype)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    aircrafttype = Repo.get!(Aircrafttype, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(aircrafttype)

    send_resp(conn, :no_content, "")
  end

end
