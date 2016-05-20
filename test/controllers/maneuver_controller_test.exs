defmodule ContestDirectorApi.ManeuverControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Maneuver
  alias ContestDirectorApi.Repo

  @valid_attrs %{kfactor: "120.5", maxscore: "120.5", minscore: "120.5", name: "some content", order: 42}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    maneuverset = Repo.insert!(%ContestDirectorApi.Maneuverset{})

    %{
      "maneuverset" => %{
        "data" => %{
          "type" => "maneuversets",
          "id" => maneuverset.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, maneuver_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    maneuver = Repo.insert! %Maneuver{}
    conn = get conn, maneuver_path(conn, :show, maneuver)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{maneuver.id}"
    assert data["type"] == "maneuver"
    assert data["attributes"]["name"] == maneuver.name
    assert data["attributes"]["order"] == maneuver.order
    assert data["attributes"]["minscore"] == maneuver.minscore
    assert data["attributes"]["maxscore"] == maneuver.maxscore
    assert data["attributes"]["kfactor"] == maneuver.kfactor
    assert data["attributes"]["maneuverset_id"] == maneuver.maneuverset_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, maneuver_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, maneuver_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuvers",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Maneuver, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, maneuver_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuvers",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    maneuver = Repo.insert! %Maneuver{}
    conn = put conn, maneuver_path(conn, :update, maneuver), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuvers",
        "id" => maneuver.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Maneuver, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    maneuver = Repo.insert! %Maneuver{}
    conn = put conn, maneuver_path(conn, :update, maneuver), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuvers",
        "id" => maneuver.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    maneuver = Repo.insert! %Maneuver{}
    conn = delete conn, maneuver_path(conn, :delete, maneuver)
    assert response(conn, 204)
    refute Repo.get(Maneuver, maneuver.id)
  end

end
