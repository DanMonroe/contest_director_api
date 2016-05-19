defmodule ContestDirectorApi.PilotController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Pilot
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    pilots = Repo.all(Pilot)
    render(conn, "index.json", data: pilots)
  end

  def create(conn, %{"data" => data = %{"type" => "pilots", "attributes" => _pilot_params}}) do
    changeset = Pilot.changeset(%Pilot{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, pilot} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pilot_path(conn, :show, pilot))
        |> render("show.json", data: pilot)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pilot = Repo.get!(Pilot, id)
    render(conn, "show.json", data: pilot)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "pilots", "attributes" => _pilot_params}}) do
    pilot = Repo.get!(Pilot, id)
    changeset = Pilot.changeset(pilot, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, pilot} ->
        render(conn, "show.json", data: pilot)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pilot = Repo.get!(Pilot, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pilot)

    send_resp(conn, :no_content, "")
  end

end
