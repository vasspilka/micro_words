defmodule MicroWords.ActionsTest do
  use MicroWords.DataCase

  alias MicroWords.Worlds

  describe "common explorer cases" do
    setup do
      {:ok, world} = Worlds.create("test_world")
      {:ok, explorer} = Worlds.Explorers.enter_world("test_world")
    end

    test "explorer can move around" do
    end
  end
end
