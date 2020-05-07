defmodule MicroWords.Repo do
  use Ecto.Repo,
    otp_app: :micro_words,
    adapter: Ecto.Adapters.Postgres
end
