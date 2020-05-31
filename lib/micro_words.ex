defmodule MicroWords do
  @moduledoc """
  MicroWords keeps the contexts that define your domain
  and business logic.

  Contexts are also responsible for managing your data, regardless
  if it comes from the database, an external API or others.
  """

  use Commanded.Application, otp_app: :micro_words

  router(MicroWords.Worlds.Router)
end
