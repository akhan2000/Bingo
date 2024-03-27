defmodule LectureBingo.Repo do
  use Ecto.Repo,
    otp_app: :lecture_bingo,
    adapter: Ecto.Adapters.SQLite3
end
