defmodule ContestDirectorApi.Pilot do
  use ContestDirectorApi.Web, :model

  schema "pilots" do
    field :firstname, :string
    field :lastname, :string
    field :email, :string
    field :phone, :string
    field :amanumber, :string

    timestamps
  end

  @required_fields ~w(firstname lastname)
  @optional_fields ~w(email phone amanumber)

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
