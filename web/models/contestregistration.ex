defmodule ContestDirectorApi.Contestregistration do
  use ContestDirectorApi.Web, :model

  schema "contestregistrations" do
    field :pilotname, :string
    belongs_to :contest, ContestDirectorApi.Contest
    belongs_to :pilotclass, ContestDirectorApi.Pilotclass
    belongs_to :pilot, ContestDirectorApi.Pilot

    timestamps
  end

  @required_fields ~w(pilotname)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
