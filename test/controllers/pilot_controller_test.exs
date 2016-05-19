defmodule ContestDirectorApi.PilotControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Pilot
  alias ContestDirectorApi.Repo

  @valid_attrs %{amanumber: "some content", email: "some content", firstname: "some content", lastname: "some content", phone: "some content"}
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
    conn = get conn, pilot_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pilot = Repo.insert! %Pilot{}
    conn = get conn, pilot_path(conn, :show, pilot)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{pilot.id}"
    assert data["type"] == "pilot"
    assert data["attributes"]["firstname"] == pilot.firstname
    assert data["attributes"]["lastname"] == pilot.lastname
    assert data["attributes"]["email"] == pilot.email
    assert data["attributes"]["phone"] == pilot.phone
    assert data["attributes"]["amanumber"] == pilot.amanumber
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pilot_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, pilot_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "pilots",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Pilot, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, pilot_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "pilots",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pilot = Repo.insert! %Pilot{}
    conn = put conn, pilot_path(conn, :update, pilot), %{
      "meta" => %{},
      "data" => %{
        "type" => "pilots",
        "id" => pilot.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pilot, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pilot = Repo.insert! %Pilot{}
    conn = put conn, pilot_path(conn, :update, pilot), %{
      "meta" => %{},
      "data" => %{
        "type" => "pilots",
        "id" => pilot.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pilot = Repo.insert! %Pilot{}
    conn = delete conn, pilot_path(conn, :delete, pilot)
    assert response(conn, 204)
    refute Repo.get(Pilot, pilot.id)
  end

end
