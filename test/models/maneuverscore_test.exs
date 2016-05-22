defmodule ContestDirectorApi.ManeuverscoreTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Maneuverscore

  @valid_attrs %{totalscore: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Maneuverscore.changeset(%Maneuverscore{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Maneuverscore.changeset(%Maneuverscore{}, @invalid_attrs)
    refute changeset.valid?
  end
end
