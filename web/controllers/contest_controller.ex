defmodule ContestDirectorApi.ContestController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Contest
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    contests = Repo.all(Contest)
    render(conn, "index.json", data: contests)
  end

  def create(conn, %{"data" => data = %{"type" => "contest", "attributes" => _contest_params}}) do
    changeset = Contest.changeset(%Contest{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, contest} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", contest_path(conn, :show, contest))
        |> render("show.json", data: contest)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    contest = Repo.get!(Contest, id)
    render(conn, "show.json", data: contest)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "contest", "attributes" => _contest_params}}) do
    contest = Repo.get!(Contest, id)
    changeset = Contest.changeset(contest, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, contest} ->
        render(conn, "show.json", data: contest)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    contest = Repo.get!(Contest, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(contest)

    send_resp(conn, :no_content, "")
  end

end
