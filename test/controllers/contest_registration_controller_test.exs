defmodule ContestDirectorApi.ContestRegistrationControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.ContestRegistration
  alias ContestDirectorApi.Repo

  @valid_attrs %{}
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
    conn = get conn, contest_registration_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    contest_registration = Repo.insert! %ContestRegistration{}
    conn = get conn, contest_registration_path(conn, :show, contest_registration)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{contest_registration.id}"
    assert data["type"] == "contest-registration"
    assert data["attributes"]["contest_id"] == contest_registration.contest_id
    assert data["attributes"]["pilotclass_id"] == contest_registration.pilotclass_id
    assert data["attributes"]["pilot_id"] == contest_registration.pilot_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, contest_registration_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, contest_registration_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "contest_registrations",
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(ContestRegistration, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, contest_registration_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "contest_registrations",
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    contest_registration = Repo.insert! %ContestRegistration{}
    conn = put conn, contest_registration_path(conn, :update, contest_registration), %{
      "meta" => %{},
      "data" => %{
        "type" => "contest_registrations",
        "id" => contest_registration.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(ContestRegistration, @valid_attrs)
  end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   contest_registration = Repo.insert! %ContestRegistration{}
  #   conn = put conn, contest_registration_path(conn, :update, contest_registration), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "contest_registrations",
  #       "id" => contest_registration.id,
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end
  #
  test "deletes chosen resource", %{conn: conn} do
    contest_registration = Repo.insert! %ContestRegistration{}
    conn = delete conn, contest_registration_path(conn, :delete, contest_registration)
    assert response(conn, 204)
    refute Repo.get(ContestRegistration, contest_registration.id)
  end

end
