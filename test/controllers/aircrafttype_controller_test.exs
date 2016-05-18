defmodule ContestDirectorApi.AircrafttypeControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Aircrafttype
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
    %{}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, aircrafttype_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    aircrafttype = Repo.insert! %Aircrafttype{}
    conn = get conn, aircrafttype_path(conn, :show, aircrafttype)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{aircrafttype.id}"
    assert data["type"] == "aircrafttype"
    assert data["attributes"]["name"] == aircrafttype.name
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, aircrafttype_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, aircrafttype_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "aircrafttypes",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Aircrafttype, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, aircrafttype_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "aircrafttypes",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    aircrafttype = Repo.insert! %Aircrafttype{}
    conn = put conn, aircrafttype_path(conn, :update, aircrafttype), %{
      "meta" => %{},
      "data" => %{
        "type" => "aircrafttypes",
        "id" => aircrafttype.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Aircrafttype, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    aircrafttype = Repo.insert! %Aircrafttype{}
    conn = put conn, aircrafttype_path(conn, :update, aircrafttype), %{
      "meta" => %{},
      "data" => %{
        "type" => "aircrafttypes",
        "id" => aircrafttype.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    aircrafttype = Repo.insert! %Aircrafttype{}
    conn = delete conn, aircrafttype_path(conn, :delete, aircrafttype)
    assert response(conn, 204)
    refute Repo.get(Aircrafttype, aircrafttype.id)
  end

end
