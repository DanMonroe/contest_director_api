defmodule ContestDirectorApi.ManeuversetTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Maneuverset

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Maneuverset.changeset(%Maneuverset{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Maneuverset.changeset(%Maneuverset{}, @invalid_attrs)
    refute changeset.valid?
  end
end
