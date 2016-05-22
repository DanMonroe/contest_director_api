defmodule ContestDirectorApi.ManeuversetControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Maneuverset
  alias ContestDirectorApi.Repo

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    pilotclass = Repo.insert!(%ContestDirectorApi.Pilotclass{})

    %{
      "pilotclass" => %{
        "data" => %{
          "type" => "pilotclasses",
          "id" => pilotclass.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, maneuverset_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    maneuverset = Repo.insert! %Maneuverset{}
    conn = get conn, maneuverset_path(conn, :show, maneuverset)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{maneuverset.id}"
    assert data["type"] == "maneuverset"
    assert data["attributes"]["name"] == maneuverset.name
    assert data["attributes"]["pilotclass_id"] == maneuverset.pilotclass_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, maneuverset_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, maneuverset_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "maneuversets",
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Maneuverset, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, maneuverset_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "maneuversets",
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    maneuverset = Repo.insert! %Maneuverset{}
    conn = put conn, maneuverset_path(conn, :update, maneuverset), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuversets",
        "id" => maneuverset.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Maneuverset, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    maneuverset = Repo.insert! %Maneuverset{}
    conn = put conn, maneuverset_path(conn, :update, maneuverset), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuversets",
        "id" => maneuverset.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    maneuverset = Repo.insert! %Maneuverset{}
    conn = delete conn, maneuverset_path(conn, :delete, maneuverset)
    assert response(conn, 204)
    refute Repo.get(Maneuverset, maneuverset.id)
  end

end
