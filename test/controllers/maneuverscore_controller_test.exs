defmodule ContestDirectorApi.ManeuverscoreControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Maneuverscore
  alias ContestDirectorApi.Repo

  @valid_attrs %{totalscore: "120.5"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    maneuver = Repo.insert!(%ContestDirectorApi.Maneuver{})
    roundscore = Repo.insert!(%ContestDirectorApi.Roundscore{})

    %{
      "maneuver" => %{
        "data" => %{
          "type" => "maneuvers",
          "id" => maneuver.id
        }
      },
      "roundscore" => %{
        "data" => %{
          "type" => "roundscores",
          "id" => roundscore.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, maneuverscore_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    maneuverscore = Repo.insert! %Maneuverscore{}
    conn = get conn, maneuverscore_path(conn, :show, maneuverscore)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{maneuverscore.id}"
    assert data["type"] == "maneuverscore"
    assert data["attributes"]["totalscore"] == maneuverscore.totalscore
    assert data["attributes"]["maneuver_id"] == maneuverscore.maneuver_id
    assert data["attributes"]["roundscore_id"] == maneuverscore.roundscore_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, maneuverscore_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, maneuverscore_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuverscores",
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Maneuverscore, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, maneuverscore_path(conn, :create), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuverscores",
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    maneuverscore = Repo.insert! %Maneuverscore{}
    conn = put conn, maneuverscore_path(conn, :update, maneuverscore), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuverscores",
        "id" => maneuverscore.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Maneuverscore, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    maneuverscore = Repo.insert! %Maneuverscore{}
    conn = put conn, maneuverscore_path(conn, :update, maneuverscore), %{
      "meta" => %{},
      "data" => %{
        "type" => "maneuverscores",
        "id" => maneuverscore.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    maneuverscore = Repo.insert! %Maneuverscore{}
    conn = delete conn, maneuverscore_path(conn, :delete, maneuverscore)
    assert response(conn, 204)
    refute Repo.get(Maneuverscore, maneuverscore.id)
  end

end
