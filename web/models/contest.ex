defmodule ContestDirectorApi.Contest do
  use ContestDirectorApi.Web, :model

  schema "contests" do
    field :name, :string
    field :slug, :string
    field :aircrafttype_id, :integer

    timestamps
  end

  @required_fields ~w(name slug)
  @optional_fields ~w(aircrafttype_id)

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
