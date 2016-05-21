defmodule ContestDirectorApi.PilotclassTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Pilotclass

  @valid_attrs %{name: "some content", order: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pilotclass.changeset(%Pilotclass{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pilotclass.changeset(%Pilotclass{}, @invalid_attrs)
    refute changeset.valid?
  end
end
