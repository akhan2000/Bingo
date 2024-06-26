defmodule LectureBingo.Games.Incident do
  use Ecto.Schema
  import Ecto.Changeset


  schema "incidents" do
    field :description, :string
    field :title, :string

    timestamps()
  end

  # def list_incidents do
  #   Repo.all(Incident)
  # end

  @doc false
  def changeset(incident, attrs) do
    incident
    |> cast(attrs, [:title, :description])
    |> validate_required([:title, :description])
  end
end
