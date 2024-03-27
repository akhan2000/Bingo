defmodule LectureBingo.Games do
  @moduledoc """
  The Games context.
  """
  import Ecto.Query, warn: false
  alias LectureBingo.Repo
  alias LectureBingo.Games.{Incident, Game}
  alias LectureBingo.Accounts.User

  def list_incidents do
    Repo.all(Incident)
  end


def initialize_game_state() do
  LectureBingo.Games.list_incidents()
    |> Enum.take_random(3)
    |> Game.create_state()
  end

  def start_game(user) do
    %{state: initialize_game_state()}
    |> create_game(user)
  end

  def toggle_incident(game, incident_id) do
    {:ok, updated_game} = game
                          |> Game.toggle_incident_changeset(incident_id)
                          |> Repo.update()
    updated_game
  end


  def create_game(attrs \\ %{}, %User{} = user) do
    %Game{}
    |> Game.changeset(attrs)
    |> Ecto.Changeset.put_assoc(:user, user)
    |> Repo.insert()
  end

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """


  def get_incident!(id), do: Repo.get!(Incident, id)

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  def get_random_incidents(count) do
    Repo.all(LectureBingo.Games.Incident) |> Enum.take_random(count)
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """

  # def changeset(game, attrs) do
  #   game
  #   |> Ecto.Changeset.cast(attrs, [:name])
  # end
  %Ecto.Changeset{data: %Game{}}
end
