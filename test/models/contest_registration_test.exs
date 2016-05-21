defmodule ContestDirectorApi.ContestRegistrationTest do
  use ContestDirectorApi.ModelCase

  alias ContestDirectorApi.ContestRegistration

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ContestRegistration.changeset(%ContestRegistration{}, @valid_attrs)
    assert changeset.valid?
  end

  # test "changeset with invalid attributes" do
  #   changeset = ContestRegistration.changeset(%ContestRegistration{}, @invalid_attrs)
  #   refute changeset.valid?
  # end
end
