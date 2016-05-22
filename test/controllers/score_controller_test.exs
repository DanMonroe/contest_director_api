defmodule ContestDirectorApi.ScoreControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Score
  alias ContestDirectorApi.Repo

  @valid_attrs %{points: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
  
  defp relationships do 
    maneuverscore = Repo.insert!(%ContestDirectorApi.Maneuverscore{})

    %{
      "maneuverscore" => %{
        "data" => %{
          "type" => "maneuverscore",
          "id" => maneuverscore.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, score_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = get conn, score_path(conn, :show, score)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{score.id}"
    assert data["type"] == "score"
    assert data["attributes"]["points"] == score.points
    assert data["attributes"]["maneuverscore_id"] == score.maneuverscore_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, score_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, score_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "score",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Score, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, score_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "score",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = put conn, score_path(conn, :update, score), %{
      "meta" => %{},
      "data" => %{
        "type" => "score",
        "id" => score.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Score, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = put conn, score_path(conn, :update, score), %{
      "meta" => %{},
      "data" => %{
        "type" => "score",
        "id" => score.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    score = Repo.insert! %Score{}
    conn = delete conn, score_path(conn, :delete, score)
    assert response(conn, 204)
    refute Repo.get(Score, score.id)
  end

end
