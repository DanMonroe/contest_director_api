defmodule ContestDirectorApi.ContestTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Contest

  @valid_attrs %{aircrafttype_id: 42, name: "some content", slug: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contest.changeset(%Contest{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with valid given attributes" do
    changeset = Contest.changeset(%Contest{}, %{name: "Test Contest",
      slug: "TestContest",
      aircrafttype_id: 1})
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contest.changeset(%Contest{}, @invalid_attrs)
    refute changeset.valid?
  end
end
