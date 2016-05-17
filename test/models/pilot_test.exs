defmodule ContestDirectorApi.PilotTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Pilot

  @valid_attrs %{amanumber: "some content", email: "some content", firstname: "some content", lastname: "some content", phone: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Pilot.changeset(%Pilot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Pilot.changeset(%Pilot{}, @invalid_attrs)
    refute changeset.valid?
  end
end
