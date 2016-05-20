defmodule ContestDirectorApi.Maneuver do
  use ContestDirectorApi.Web, :model

  schema "maneuvers" do
    field :name, :string
    field :order, :integer
    field :minscore, :float
    field :maxscore, :float
    field :kfactor, :float
    belongs_to :maneuverset, ContestDirectorApi.Maneuverset

    timestamps
  end

  @required_fields ~w(name order minscore maxscore kfactor)
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
