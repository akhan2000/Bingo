defmodule LectureBingo.Games.Game do
  use Ecto.Schema
  import Ecto.Changeset

  schema "games" do
    belongs_to :user, LectureBingo.Accounts.User
    field :state, {:array, :map}
     timestamps()
end

def create_state(incidents) do
  Enum.map(incidents, fn i -> %{id: i.id, title: i.title, description: i.description, occurred: false} end)
end

def state_for_incident_toggle(game, incident_id) do
  Enum.map(game.state, fn i ->
    if i.id == String.to_integer(incident_id),
    do: Map.put(i, :occurred, !i.occurred), else: i end)
  end

  def victorious(game) do
    game.state
    |> Enum.filter(&(&1.occurred == false))
    |> Enum.empty?
  end


  def toggle_incident_changeset(game, incident_id) do
    attrs = %{state: state_for_incident_toggle(game, incident_id)}
    game
    |> change(attrs)
  end


  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:state])
    |> validate_required([:state])
  end
end
