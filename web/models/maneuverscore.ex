defmodule ContestDirectorApi.Maneuverscore do
  use ContestDirectorApi.Web, :model

  schema "maneuverscores" do
    field :totalscore, :float
    belongs_to :maneuver, ContestDirectorApi.Maneuver
    belongs_to :roundscore, ContestDirectorApi.Roundscore

    has_many :scores, ContestDirectorApi.Score

    timestamps
  end

  @required_fields ~w(totalscore)
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
