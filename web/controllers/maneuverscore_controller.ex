defmodule ContestDirectorApi.ManeuverscoreController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Maneuverscore
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    maneuverscores = Repo.all(Maneuverscore)
    render(conn, "index.json", data: maneuverscores)
  end

  def create(conn, %{"data" => data = %{"type" => "maneuverscores", "attributes" => _maneuverscore_params}}) do
    changeset = Maneuverscore.changeset(%Maneuverscore{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, maneuverscore} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", maneuverscore_path(conn, :show, maneuverscore))
        |> render("show.json", data: maneuverscore)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    maneuverscore = Repo.get!(Maneuverscore, id)
    render(conn, "show.json", data: maneuverscore)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "maneuverscores", "attributes" => _maneuverscore_params}}) do
    maneuverscore = Repo.get!(Maneuverscore, id)
    changeset = Maneuverscore.changeset(maneuverscore, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, maneuverscore} ->
        render(conn, "show.json", data: maneuverscore)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    maneuverscore = Repo.get!(Maneuverscore, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(maneuverscore)

    send_resp(conn, :no_content, "")
  end

end
