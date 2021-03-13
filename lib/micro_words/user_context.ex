defmodule MicroWords.UserContext do
  use TypedStruct

  alias MicroWords.Explorers.Explorer
  alias MicroWords.Worlds.Location

  @derive Jason.Encoder
  typedstruct do
    field :explorer, Explorer.t()
    field :location, Location.t()
    # TODO: define properly
    field :page_info, %{
      input_form_data: binary(),
      selected_artefact: binary()
    }
  end
end
