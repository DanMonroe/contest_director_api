defmodule ContestDirectorApi.Round do
  use ContestDirectorApi.Web, :model

  schema "rounds" do
    field :name, :string
    field :order, :integer
    field :numjudges, :integer
    field :drophigh, :integer
    field :droplow, :integer
    belongs_to :contest, ContestDirectorApi.Contest
    belongs_to :pilotclass, ContestDirectorApi.Pilotclass
    belongs_to :maneuverset, ContestDirectorApi.Maneuverset

    timestamps
  end

  @required_fields ~w(name order numjudges drophigh droplow)
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
