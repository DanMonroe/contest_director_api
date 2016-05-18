require IEx

defmodule ContestDirectorApi.PilotclassController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Pilotclass
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    pilotclasses = Repo.all(Pilotclass)
    render(conn, "index.json", data: pilotclasses)
  end

  def create(conn, %{"data" => data = %{"type" => "pilotclasses", "attributes" => _pilotclass_params, "relationships" => _}}) do
    IEx.pry

    changeset = Pilotclass.changeset(%Pilotclass{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, pilotclass} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", pilotclass_path(conn, :show, pilotclass))
        |> render("show.json", data: pilotclass)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    pilotclass = Repo.get!(Pilotclass, id)
    render(conn, "show.json", data: pilotclass)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "pilotclasses", "attributes" => _pilotclass_params}}) do
    pilotclass = Repo.get!(Pilotclass, id)
    changeset = Pilotclass.changeset(pilotclass, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, pilotclass} ->
        render(conn, "show.json", data: pilotclass)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    pilotclass = Repo.get!(Pilotclass, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(pilotclass)

    send_resp(conn, :no_content, "")
  end

end
