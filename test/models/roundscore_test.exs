defmodule ContestDirectorApi.RoundscoreTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Roundscore

  @valid_attrs %{normalizedscore: "120.5", totalroundscore: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Roundscore.changeset(%Roundscore{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Roundscore.changeset(%Roundscore{}, @invalid_attrs)
    refute changeset.valid?
  end
end
