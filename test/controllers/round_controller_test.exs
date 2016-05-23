defmodule ContestDirectorApi.RoundControllerTest do
  use ContestDirectorApi.ConnCase
  # import Ecto, only: [build_assoc: 2]
  # import ContestDirectorApi.ContestregistrationController, only: [find_contestregistrations_by_contest_and_pilotclass: 2]

  require Logger

  alias ContestDirectorApi.Round
  alias ContestDirectorApi.Repo

  @valid_attrs %{drophigh: 42, droplow: 42, name: "some content", numjudges: 42, order: 42}
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
    maneuverset = Repo.insert!(%ContestDirectorApi.Maneuverset{})

    %{
      "contest" => %{
        "data" => %{
          "type" => "contests",
          "id" => contest.id
        }
      },
      "pilotclass" => %{
        "data" => %{
          "type" => "pilotclasses",
          "id" => pilotclass.id
        }
      },
      "maneuverset" => %{
        "data" => %{
          "type" => "maneuversets",
          "id" => maneuverset.id
        }
      },
    }
  end

  # defp create_maneuver_set do
  #   Repo.insert! %ContestDirectorApi.Maneuverset{name: "Sportsman", id: 1}
  # end

  test "list only maneuver set 1 test maneuvers" do
    man_set1 =  Repo.insert! %ContestDirectorApi.Maneuverset{name: "Sportsman", id: 1}
    # Logger.error(man_set1.name)

    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "First", order: 1}
    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "Second", order: 2}
    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "Third", order: 3}
    # create_maneuvers man_set1

    actual_maneuvers = ContestDirectorApi.ManeuverController.find_maneuvers_by_maneuverset_id man_set1.id
    assert 3 == Enum.count(actual_maneuvers)

    # Enum.each(actual_maneuvers, fn(m) ->
    #   Logger.warn(m.name)
    # end)
  end

  # defp find_contestregistrations_by_contest_and_pilotclass(contest_id, pilotclass_id) do
  #   Logger.error("here 2")
  #   # order_by: cr.pilotnumber,
  #   query = from cr in Contestregistration,
  #     where: cr.contest_id == ^contest_id and cr.pilotclass_id == ^pilotclass_id,
  #     select: cr
  #   Repo.all(query)
  # end
  #

  test "list only contest registrations by contest id and pilot class id" do
    contest1 = Repo.insert! %ContestDirectorApi.Contest{name: "Beauty", id: 1}
    assert "Beauty" = contest1.name
    assert 1 = contest1.id

    pilotclass1 = Repo.insert! %ContestDirectorApi.Pilotclass{name: "Sportsman", id: 1}
    assert "Sportsman" = pilotclass1.name
    assert 1 = pilotclass1.id

    pilotclass2 = Repo.insert! %ContestDirectorApi.Pilotclass{name: "Advanced", id: 2}
    assert "Advanced" = pilotclass2.name
    assert 2 = pilotclass2.id

    Repo.insert! %ContestDirectorApi.Contestregistration{contest_id: contest1.id, pilotclass_id: pilotclass1.id, pilotname: "Rebel"}
    Repo.insert! %ContestDirectorApi.Contestregistration{contest_id: contest1.id, pilotclass_id: pilotclass1.id, pilotname: "Dixie"}
    Repo.insert! %ContestDirectorApi.Contestregistration{contest_id: contest1.id, pilotclass_id: pilotclass1.id, pilotname: "Jack"}

    actual_registrations = ContestDirectorApi.ContestregistrationController.find_contestregistrations_by_contest_and_pilotclass(contest1.id, pilotclass1.id)
    assert 3 == Enum.count(actual_registrations)
  end

  test "create a round" do
    man_set1 =  Repo.insert! %ContestDirectorApi.Maneuverset{name: "Sportsman", id: 1}
    contest1 = Repo.insert! %ContestDirectorApi.Contest{name: "Beast", id: 2}
    pilotclass1 = Repo.insert! %ContestDirectorApi.Pilotclass{name: "Sportsman", id: 4}

    round1 = Repo.insert! %ContestDirectorApi.Round{
      name: "Round 1",
      numjudges: 5,
      drophigh: 2,
      droplow: 1,
      maneuverset_id: man_set1.id,
      contest_id: contest1.id,
      pilotclass_id: pilotclass1.id
    }

    assert "Round 1" == round1.name
    assert 5 == round1.numjudges
    assert 2 == round1.drophigh
    assert 1 == round1.droplow
    assert 1 == round1.maneuverset_id
    assert 2 == round1.contest_id
    assert 4 == round1.pilotclass_id
  end

  test "create a round score for each contest registration" do
    man_set1 =  Repo.insert! %ContestDirectorApi.Maneuverset{name: "Sportsman", id: 1}
    contest1 = Repo.insert! %ContestDirectorApi.Contest{name: "Beast", id: 2}
    pilotclass1 = Repo.insert! %ContestDirectorApi.Pilotclass{name: "Sportsman", id: 4}

    reg1 = Repo.insert! %ContestDirectorApi.Contestregistration{id: 1, contest_id: contest1.id, pilotclass_id: pilotclass1.id, pilotname: "Rebel"}
    reg2 = Repo.insert! %ContestDirectorApi.Contestregistration{id: 2, contest_id: contest1.id, pilotclass_id: pilotclass1.id, pilotname: "Dixie"}
    reg3 = Repo.insert! %ContestDirectorApi.Contestregistration{id: 3, contest_id: contest1.id, pilotclass_id: pilotclass1.id, pilotname: "Jack"}

    # Logger.warn(reg1.id)
    # Logger.warn(reg2.id)
    # Logger.warn(reg3.id)

    Logger.error("Creating new Round")

    round1 = Repo.insert! %ContestDirectorApi.Round{
      name: "Round 1",
      numjudges: 5,
      drophigh: 2,
      droplow: 1,
      maneuverset_id: man_set1.id,
      contest_id: contest1.id,
      pilotclass_id: pilotclass1.id
    }

    assert "Round 1" == round1.name
    assert 5 == round1.numjudges
    assert 2 == round1.drophigh
    assert 1 == round1.droplow
    assert 1 == round1.maneuverset_id
    assert 2 == round1.contest_id
    assert 4 == round1.pilotclass_id

    Logger.warn("creating maneuvers")
    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "First", order: 1}
    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "Second", order: 2}
    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "Third", order: 3}
    Repo.insert! %ContestDirectorApi.Maneuver{maneuverset_id: man_set1.id, name: "Fourth", order: 4}

    # create_maneuvers man_set1

    actual_maneuvers = ContestDirectorApi.ManeuverController.find_maneuvers_by_maneuverset_id man_set1.id

    Logger.warn("Maneuvers found: " <> to_string(Enum.count(actual_maneuvers)))
    # Logger.warn(Enum.count(actual_maneuvers))

    Logger.warn("searching for registrations")

    registrations = ContestDirectorApi.ContestregistrationController.find_contestregistrations_by_contest_and_pilotclass(contest1.id, pilotclass1.id)

    Logger.warn("Registrations found: " <> to_string(Enum.count(registrations)))

    Logger.warn("Looping through registrations")
    Enum.each(registrations, fn(registration) ->
      Logger.warn("This registration for " <> registration.pilotname)
      Logger.error("Creating new roundscore")
      rndscore = Repo.insert! %ContestDirectorApi.Roundscore{contestregistration: registration, round: round1, totalroundscore: 0.0}

      Logger.warn("     pilot: " <> rndscore.contestregistration.pilotname)
      Logger.warn("     totalscore: " <> to_string(rndscore.totalroundscore))
      Logger.warn("     round name: " <> rndscore.round.name)

      Logger.warn("   Looping through maneuvers")
      Enum.each(actual_maneuvers, fn(thismaneuver) ->
      Logger.warn("     this maneuver name: " <> thismaneuver.name)
      Logger.warn("       Creating new maneuver score")
        manscore = Repo.insert! %ContestDirectorApi.Maneuverscore{
          maneuver: thismaneuver,
          roundscore: rndscore,
          totalscore: 0.0}
      Logger.warn("         Creating new scores for " <> manscore.maneuver.name)
        Enum.each 1..round1.numjudges, fn(_) ->
          newscore = Repo.insert! %ContestDirectorApi.Score{
            points: 0.0,
            maneuverscore: manscore
          }
      Logger.warn("           score points: " <> to_string(newscore.points))
        end
      end)
    end)

    allscores = Repo.all(from scores in ContestDirectorApi.Score, select: scores)

    assert 60 == Enum.count(allscores)

    # rstest = Repo.insert! %ContestDirectorApi.Roundscore{contestregistration: reg1, round: round1, totalroundscore: 10.0}
    # Logger.error(" id: " <> to_string(rstest.id))
    # Logger.error(rstest.contestregistration.pilotname)
    # Logger.error("   cr id: " <> to_string(rstest.contestregistration.id))
    # Logger.error("   rs totalscore: " <> to_string(rstest.totalroundscore))
    #
    # query = from roundscore in ContestDirectorApi.Roundscore,
    #   where: roundscore.contestregistration_id == ^reg1.id,
    #   select: roundscore
    # test = Repo.all(query)

    # Logger.warn("Test: " <> test)
    # test = Repo.get(ContestDirectorApi.Roundscore, reg1.id)

    # actual_roundscores1 = ContestDirectorApi.RoundscoreController.find_roundscores_by_contestregistration(reg1.id)
    # assert 1 == Enum.count(actual_roundscores1)
  end



  test "lists all entries on index", %{conn: conn} do
    conn = get conn, round_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = get conn, round_path(conn, :show, round)
    data = json_response(conn, 200)["data"]
    assert data["id"] == "#{round.id}"
    assert data["type"] == "round"
    assert data["attributes"]["name"] == round.name
    assert data["attributes"]["order"] == round.order
    assert data["attributes"]["numjudges"] == round.numjudges
    assert data["attributes"]["drophigh"] == round.drophigh
    assert data["attributes"]["droplow"] == round.droplow
    assert data["attributes"]["contest_id"] == round.contest_id
    assert data["attributes"]["pilotclass_id"] == round.pilotclass_id
    assert data["attributes"]["maneuverset_id"] == round.maneuverset_id
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, round_path(conn, :show, -1)
    end
  end

  # test "creates and renders resource when data is valid", %{conn: conn} do
  #   conn = post conn, round_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "rounds",
  #       "attributes" => @valid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 201)["data"]["id"]
  #   assert Repo.get_by(Round, @valid_attrs)
  # end
  #
  # test "does not create resource and renders errors when data is invalid", %{conn: conn} do
  #   conn = post conn, round_path(conn, :create), %{
  #     "meta" => %{},
  #     "data" => %{
  #       "type" => "rounds",
  #       "attributes" => @invalid_attrs,
  #       "relationships" => relationships
  #     }
  #   }
  #
  #   assert json_response(conn, 422)["errors"] != %{}
  # end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = put conn, round_path(conn, :update, round), %{
      "meta" => %{},
      "data" => %{
        "type" => "rounds",
        "id" => round.id,
        "attributes" => @valid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Round, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = put conn, round_path(conn, :update, round), %{
      "meta" => %{},
      "data" => %{
        "type" => "rounds",
        "id" => round.id,
        "attributes" => @invalid_attrs,
        "relationships" => relationships
      }
    }

    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    round = Repo.insert! %Round{}
    conn = delete conn, round_path(conn, :delete, round)
    assert response(conn, 204)
    refute Repo.get(Round, round.id)
  end

end
