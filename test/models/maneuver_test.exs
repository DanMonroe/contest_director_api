defmodule ContestDirectorApi.ManeuverTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Maneuver

  @valid_attrs %{kfactor: "120.5", maxscore: "120.5", minscore: "120.5", name: "some content", order: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Maneuver.changeset(%Maneuver{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Maneuver.changeset(%Maneuver{}, @invalid_attrs)
    refute changeset.valid?
  end
end
