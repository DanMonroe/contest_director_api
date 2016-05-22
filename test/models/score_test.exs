defmodule ContestDirectorApi.ScoreTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Score

  @valid_attrs %{points: "120.5"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Score.changeset(%Score{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Score.changeset(%Score{}, @invalid_attrs)
    refute changeset.valid?
  end
end
