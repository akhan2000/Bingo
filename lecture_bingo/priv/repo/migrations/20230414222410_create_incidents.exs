defmodule LectureBingo.Repo.Migrations.CreateIncidents do
  use Ecto.Migration

  def change do
    create table(:incidents) do
      add :title, :string
      add :description, :string

      timestamps()
    end
  end
end
