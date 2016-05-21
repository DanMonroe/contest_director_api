defmodule ContestDirectorApi.PilotclassControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Pilotclass
  alias ContestDirectorApi.Repo

  @valid_attrs %{name: "some content", order: 1}
  @invalid_attrs %{}

  setup do
    conn = conn()
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end

  defp relationships do
    aircrafttype = Repo.insert!(%ContestDirectorApi.Aircrafttype{})

    %{
      "aircrafttype" => %{
        "data" => %{
          "type" => "aircrafttype",
          "id" => aircrafttype.id
        }
      },
    }
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, pilotclass_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    pilotclass = Repo.insert! %Pilotclass{}
    conn = get conn, pilotclass_path(conn, :show, pilotclass)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{pilotclass.id}"
    assert data["type"] == "pilotclass"
    assert data["attributes"]["name"] == pilotclass.name
    assert data["attributes"]["order"] == pilotclass.order
    assert data["attributes"]["aircrafttype_id"] == pilotclass.aircrafttype_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, pilotclass_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, pilotclass_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "pilotclasses",
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Pilotclass, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, pilotclass_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "pilotclasses",
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    pilotclass = Repo.insert! %Pilotclass{}
    conn = put conn, pilotclass_path(conn, :update, pilotclass), %{
      "meta" => %{},
      "data" => %{
        "type" => "pilotclasses",
        "id" => pilotclass.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Pilotclass, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    pilotclass = Repo.insert! %Pilotclass{}
    conn = put conn, pilotclass_path(conn, :update, pilotclass), %{
      "meta" => %{},
      "data" => %{
        "type" => "pilotclasses",
        "id" => pilotclass.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    pilotclass = Repo.insert! %Pilotclass{}
    conn = delete conn, pilotclass_path(conn, :delete, pilotclass)
    assert response(conn, 204)
    refute Repo.get(Pilotclass, pilotclass.id)
  end

end
