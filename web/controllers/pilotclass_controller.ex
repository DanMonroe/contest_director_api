defmodule ContestDirectorApi.PilotclassController do
  require Logger

  use ContestDirectorApi.Web, :controller

  # import Ecto.Query
  import Ecto.Query, only: [from: 2]

  alias ContestDirectorApi.Pilotclass
  alias JaSerializer.Params

  plug :scrub_params, "data" when action in [:create, :update]

  def index(conn, params) do
    aircrafttypeId = params["filter"]["aircrafttypeId"]
    if params["filter"]["aircrafttypeId"] do
      # aircrafttypeId = params["filter"]["aircrafttypeId"]
      query = from p in Pilotclass,
        where: p.aircrafttype_id == ^aircrafttypeId,
        order_by: p.order,
        select: p
      pilotclasses = Repo.all(query)
    else
      pilotclasses = Repo.all(Pilotclass)
    end
    render(conn, "index.json", data: pilotclasses)
  end

  # def create(conn, %{"data" => data}) do
  #     attrs = JaSerializer.Params.to_attributes(data)
  #     changeset = Pilotclass.changeset(%Pilotclass{}, attrs)
  #     case Repo.insert(changeset) do
  #       {:ok, pilotclass} ->
  #         conn
  #         |> put_status(201)
  #         |> render(:show, data: pilotclass)
  #       {:error, changeset} ->
  #         conn
  #         |> put_status(422)
  #         |> render(:errors, data: changeset)
  #     end
  #   end
  #
  def create(conn, %{"data" => data = %{"type" => "pilotclasses",
    "attributes" => _pilotclass_params,
    "relationships" => relationship_params}}) do

    changeset = Pilotclass.changeset(%Pilotclass{
      aircrafttype_id: String.to_integer(relationship_params["aircrafttype"]["data"]["id"])
      }, Params.to_attributes(data))

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
