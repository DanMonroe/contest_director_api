defmodule ContestDirectorApi.RoundTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Round

  @valid_attrs %{drophigh: 42, droplow: 42, name: "some content", numjudges: 42, order: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Round.changeset(%Round{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Round.changeset(%Round{}, @invalid_attrs)
    refute changeset.valid?
  end
end
