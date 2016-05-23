defmodule ContestDirectorApi.ContestControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Contest
  alias ContestDirectorApi.ContestController
  alias ContestDirectorApi.Repo

  @valid_attrs %{aircrafttype_id: 42, name: "some content", slug: "some content"}
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
    conn = get conn, contest_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end


  test "get contest set by id" do
    Repo.insert! %ContestDirectorApi.Contest{name: "Beast", id: 2}

    actual_contest = ContestController.get_contest_by_id 2
    assert "Beast" == actual_contest.name
    assert 2 == actual_contest.id
  end

  test "shows chosen resource", %{conn: conn} do
    contest = Repo.insert! %Contest{}
    conn = get conn, contest_path(conn, :show, contest)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{contest.id}"
    assert data["type"] == "contest"
    assert data["attributes"]["name"] == contest.name
    assert data["attributes"]["slug"] == contest.slug
    assert data["attributes"]["aircrafttype_id"] == contest.aircrafttype_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, contest_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, contest_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "contests",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Contest, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, contest_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "contests",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    contest = Repo.insert! %Contest{}
    conn = put conn, contest_path(conn, :update, contest), %{
      "meta" => %{},
      "data" => %{
        "type" => "contests",
        "id" => contest.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Contest, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    contest = Repo.insert! %Contest{}
    conn = put conn, contest_path(conn, :update, contest), %{
      "meta" => %{},
      "data" => %{
        "type" => "contests",
        "id" => contest.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    contest = Repo.insert! %Contest{}
    conn = delete conn, contest_path(conn, :delete, contest)
    assert response(conn, 204)
    refute Repo.get(Contest, contest.id)
  end

end
