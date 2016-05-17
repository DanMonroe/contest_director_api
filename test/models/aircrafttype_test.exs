defmodule ContestDirectorApi.AircrafttypeTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Aircrafttype

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Aircrafttype.changeset(%Aircrafttype{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Aircrafttype.changeset(%Aircrafttype{}, @invalid_attrs)
    refute changeset.valid?
  end
end
