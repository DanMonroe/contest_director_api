defmodule ContestDirectorApi.RoundscoreControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Roundscore
  alias ContestDirectorApi.Repo

  @valid_attrs %{normalizedscore: "120.5", totalroundscore: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    contestregistration = Repo.insert!(%ContestDirectorApi.Contestregistration{})
    round = Repo.insert!(%ContestDirectorApi.Round{})

    %{
      "contestregistration" => %{
        "data" => %{
          "type" => "contestregistrations",
          "id" => contestregistration.id
        }
      },
      "round" => %{
        "data" => %{
          "type" => "rounds",
          "id" => round.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, roundscore_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    roundscore = Repo.insert! %Roundscore{}
    conn = get conn, roundscore_path(conn, :show, roundscore)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{roundscore.id}"
    assert data["type"] == "roundscore"
    assert data["attributes"]["totalroundscore"] == roundscore.totalroundscore
    assert data["attributes"]["normalizedscore"] == roundscore.normalizedscore
    assert data["attributes"]["contestregistration_id"] == roundscore.contestregistration_id
    assert data["attributes"]["round_id"] == roundscore.round_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, roundscore_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, roundscore_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "roundscores",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Roundscore, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, roundscore_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "roundscores",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    roundscore = Repo.insert! %Roundscore{}
    conn = put conn, roundscore_path(conn, :update, roundscore), %{
      "meta" => %{},
      "data" => %{
        "type" => "roundscores",
        "id" => roundscore.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Roundscore, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    roundscore = Repo.insert! %Roundscore{}
    conn = put conn, roundscore_path(conn, :update, roundscore), %{
      "meta" => %{},
      "data" => %{
        "type" => "roundscores",
        "id" => roundscore.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    roundscore = Repo.insert! %Roundscore{}
    conn = delete conn, roundscore_path(conn, :delete, roundscore)
    assert response(conn, 204)
    refute Repo.get(Roundscore, roundscore.id)
  end

end
