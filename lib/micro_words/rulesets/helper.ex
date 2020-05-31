defmodule MicroWords.Ruleset.Helper do
  # Possible actions
  # Visit Artefact: Visits artefact receiving some of its energy (artefact -> explorer)
  # Spawn Artefact: Spawn a artefact by spending some energy (explorer -> artefact)
  # Feed Artefact: Spend some energy to give to artefact (explorer -> artefact)
  # Smack Artefact: Spend some energy to distrupt the bost (both lose, world gets)
  # Leach Artefact: (artefact -> explorer)
  # Protect Artefact:
  # Disenchant Artefact:

  defmodule Action do
    defstruct [:name, :function]

    def apply_function() do
    end
  end

  def get_default() do
    %{
      world: %{
        energy: 100_000
      },
      explorer: %{
        actions: [
          %{
            module: MicroWords.Ruleset.Default,
            name: :spawn
          },
          %{
            module: MicroWords.Ruleset.Default,
            name: :view_artefact
          }
        ]
      }
    }
  end
end
