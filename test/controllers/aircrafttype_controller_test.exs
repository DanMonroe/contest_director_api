defmodule ContestDirectorApi.AircrafttypeControllerTest do
  use ContestDirectorApi.ConnCase

  alias ContestDirectorApi.Aircrafttype

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup %{conn: conn} do
    conn = conn
      |> put_req_header("accept", "application/vnd.api+json")
      |> put_req_header("content-type", "application/vnd.api+json")

    {:ok, conn: conn}
  end
#  put_req_header(conn, "accept", "application/json")
   

  test "lists all entries on index", %{conn: conn} do
    # Build test aircraft types
    create_test_aircrafttypes
    # List of all rooms
    conn = get conn, aircrafttype_path(conn, :index)
    assert Enum.count(json_response(conn, 200)["data"]) == 3
  end


  # test "lists all entries on index", %{conn: conn} do
  #   conn = get conn, aircrafttype_path(conn, :index)
  #   assert json_response(conn, 200)["data"] == []
  # end

  # test "shows chosen resource", %{conn: conn} do
  #   aircrafttype = Repo.insert! %Aircrafttype{}
  #   conn = get conn, aircrafttype_path(conn, :show, aircrafttype)
  #   assert json_response(conn, 200)["data"] == %{"id" => aircrafttype.id,
  #     "name" => aircrafttype.name}
  # end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, aircrafttype_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, aircrafttype_path(conn, :create), data: %{attributes: @valid_attrs}
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Aircrafttype, @valid_attrs)
  # end

  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, aircrafttype_path(conn, :create),  data: %{attributes: @invalid_attrs}
  #   assert json_response(conn, 422)["errors"] != %{}
  # end





test "shows chosen resource", %{conn: conn} do
  aircrafttype = Repo.insert! %Aircrafttype{}
  conn = get conn, aircrafttype_path(conn, :show, aircrafttype)
  assert json_response(conn, 200)["data"] == %{
    "id" => "#{aircrafttype.id}",
    "type" => "aircrafttype",
    "attributes" => %{
      "name" => aircrafttype.name
    }
  }
end

  # test "shows chosen resource", %{conn: conn} do
  #   aircrafttype = Repo.insert! %Aircrafttype{}
  #   conn = get conn, aircrafttype_path(conn, :show, aircrafttype)
  #   assert json_response(conn, 200)["data"] == %{"id" => aircrafttype.id,
  #     "name" => aircrafttype.name}
  # end


  defp create_test_aircrafttypes() do
    # Create three rooms owned by the logged in user
    Enum.each ["Helicopter", "Airplane", "Rock"], fn name -> 
      Repo.insert! %ContestDirectorApi.Aircrafttype{name: name}
    end
  end

  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   aircrafttype = Repo.insert! %Aircrafttype{}
  #   conn = put conn, aircrafttype_path(conn, :update, aircrafttype), data: %{ attributes: @valid_attrs }
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(Aircrafttype, @valid_attrs)
  # end
  
  # test "updates and renders chosen resource when data is valid", %{conn: conn} do
  #   aircrafttype = Repo.insert! %Aircrafttype{}
  #   conn = put conn, aircrafttype_path(conn, :update, aircrafttype), aircrafttype: @valid_attrs
  #   assert json_response(conn, 200)["data"]["id"]
  #   assert Repo.get_by(Aircrafttype, @valid_attrs)
  # end

  # test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
  #   aircrafttype = Repo.insert! %Aircrafttype{}
  #   conn = put conn, aircrafttype_path(conn, :update, aircrafttype), aircrafttype: @invalid_attrs
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  # test "deletes chosen resource", %{conn: conn} do
  #   aircrafttype = Repo.insert! %Aircrafttype{}
  #   conn = delete conn, aircrafttype_path(conn, :delete, aircrafttype)
  #   assert response(conn, 204)
  #   refute Repo.get(Aircrafttype, aircrafttype.id)
  # end
end
