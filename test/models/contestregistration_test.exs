defmodule ContestDirectorApi.ContestregistrationTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.Contestregistration

  @valid_attrs %{pilotname: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Contestregistration.changeset(%Contestregistration{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Contestregistration.changeset(%Contestregistration{}, @invalid_attrs)
    refute changeset.valid?
  end
end
