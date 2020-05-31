defmodule MicroWords.Worlds.Artefacts do
  alias MicroWords.Repo
  alias MicroWords.Worlds.Artefacts.Schema

  def all do
    Repo.all(Schema)
  end
end
