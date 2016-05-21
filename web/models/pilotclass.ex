defmodule ContestDirectorApi.Pilotclass do
  use ContestDirectorApi.Web, :model

  schema "pilotclasses" do
    field :name, :string
    field :order, :integer
    belongs_to :aircrafttype, ContestDirectorApi.Aircrafttype
    has_many :maneuversets, ContestDirectorApi.Manueverset
    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(order)

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
