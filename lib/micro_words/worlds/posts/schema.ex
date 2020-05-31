defmodule MicroWords.Worlds.Artefacts.Schema do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "artefacts" do
    field :world, :string
    field :explorer_id, Ecto.UUID
    field :content, :string
    field :visible, :boolean

    timestamps()
  end

  @doc false
  def changeset(schema, attrs) do
    schema
    |> cast(attrs, [:id, :content])
    |> validate_required([:id, :content])
  end
end
