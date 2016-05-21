defmodule ContestDirectorApi.ContestregistrationControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Contestregistration
  alias ContestDirectorApi.Repo

  @valid_attrs %{pilotname: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    contest = Repo.insert!(%ContestDirectorApi.Contest{})
    pilotclass = Repo.insert!(%ContestDirectorApi.Pilotclass{})
    pilot = Repo.insert!(%ContestDirectorApi.Pilot{})

    %{
      "contest" => %{
        "data" => %{
          "type" => "contest",
          "id" => contest.id
        }
      },
      "pilotclass" => %{
        "data" => %{
          "type" => "pilotclass",
          "id" => pilotclass.id
        }
      },
      "pilot" => %{
        "data" => %{
          "type" => "pilot",
          "id" => pilot.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, contestregistration_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    contestregistration = Repo.insert! %Contestregistration{}
    conn = get conn, contestregistration_path(conn, :show, contestregistration)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{contestregistration.id}"
    assert data["type"] == "contestregistration"
    assert data["attributes"]["pilotname"] == contestregistration.pilotname
    assert data["attributes"]["contest_id"] == contestregistration.contest_id
    assert data["attributes"]["pilotclass_id"] == contestregistration.pilotclass_id
    assert data["attributes"]["pilot_id"] == contestregistration.pilot_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, contestregistration_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, contestregistration_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "contestregistrations",
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Contestregistration, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, contestregistration_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "contestregistrations",
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    contestregistration = Repo.insert! %Contestregistration{}
    conn = put conn, contestregistration_path(conn, :update, contestregistration), %{
      "meta" => %{},
      "data" => %{
        "type" => "contestregistrations",
        "id" => contestregistration.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Contestregistration, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    contestregistration = Repo.insert! %Contestregistration{}
    conn = put conn, contestregistration_path(conn, :update, contestregistration), %{
      "meta" => %{},
      "data" => %{
        "type" => "contestregistrations",
        "id" => contestregistration.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    contestregistration = Repo.insert! %Contestregistration{}
    conn = delete conn, contestregistration_path(conn, :delete, contestregistration)
    assert response(conn, 204)
    refute Repo.get(Contestregistration, contestregistration.id)
  end

end
