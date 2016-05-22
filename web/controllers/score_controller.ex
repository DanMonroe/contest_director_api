defmodule ContestDirectorApi.ScoreController do
  use ContestDirectorApi.Web, :controller

  alias ContestDirectorApi.Score
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, _params) do
    scores = Repo.all(Score)
    render(conn, "index.json", data: scores)
  end

  def create(conn, %{"data" => data = %{"type" => "score", "attributes" => _score_params}}) do
    changeset = Score.changeset(%Score{}, Params.to_attributes(data))

    case Repo.insert(changeset) do
      {:ok, score} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", score_path(conn, :show, score))
        |> render("show.json", data: score)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    score = Repo.get!(Score, id)
    render(conn, "show.json", data: score)
  end

  def update(conn, %{"id" => id, "data" => data = %{"type" => "score", "attributes" => _score_params}}) do
    score = Repo.get!(Score, id)
    changeset = Score.changeset(score, Params.to_attributes(data))

    case Repo.update(changeset) do
      {:ok, score} ->
        render(conn, "show.json", data: score)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ContestDirectorApi.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    score = Repo.get!(Score, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(score)

    send_resp(conn, :no_content, "")
  end

end
