defmodule MicroWords.Worlds.ExplorersTest do
  use MicroWords.DataCase
  import Commanded.Assertions.EventAssertions

  alias MicroWords.Worlds

  alias MicroWords.Events.{
    WorldCreated,
    ExplorerEnteredWorld,
    ExplorerReceivedRuleset,
    ExplorerMoved
  }

  describe "common explorer cases" do
    setup do
      {:ok, world} = Worlds.create("test_world")
      {:ok, explorer} = Worlds.Explorers.enter_world("explorer", "test_world")

      assert_receive_event(MicroWords, WorldCreated, fn event, _recorded_event ->
        assert event.name == "test_world"
      end)

      assert_receive_event(MicroWords, ExplorerEnteredWorld, fn event, _recorded_event ->
        assert event.world == "test_world"
        assert event.id == "explorer"
      end)

      assert_receive_event(MicroWords, ExplorerReceivedRuleset, fn event, _recorded_event ->
        assert event.ruleset == world.ruleset
      end)

      {:ok, world: world, explorer: explorer}
    end

    test "explorer can move around correctly", %{world: world, explorer: explorer} do
      {max_x, max_y} = world.ruleset.dimensions()

      assert {:ok, %{location: {^max_x, 1}}} = Worlds.Explorers.move(explorer.id, :west)

      assert_receive_event(MicroWords, ExplorerMoved, fn event, _recorded_event ->
        assert event.location == {max_x, 1}
      end)

      assert {:ok, %{location: {1, 1}}} = Worlds.Explorers.move(explorer.id, :east)

      # assert_receive_event(MicroWords, ExplorerMoved, fn event, _recorded_event ->
      #   assert event.location == {1, 1}
      # end)

      assert {:ok, %{location: {2, 1}}} = Worlds.Explorers.move(explorer.id, :east)

      # assert_receive_event(MicroWords, ExplorerMoved, fn event, _recorded_event ->
      #   assert event.location == {2, 1}
      # end)

      assert {:ok, %{location: {2, 2}}} = Worlds.Explorers.move(explorer.id, :north)

      # assert_receive_event(MicroWords, ExplorerMoved, fn event, _recorded_event ->
      #   assert event.location == {2, 2}
      # end)

      assert {:ok, %{location: {2, 1}}} = Worlds.Explorers.move(explorer.id, :south)

      # assert_receive_event(MicroWords, ExplorerMoved, fn event, _recorded_event ->
      #   assert event.location == {2, 1}
      # end)

      assert {:ok, %{location: {2, ^max_y}}} = Worlds.Explorers.move(explorer.id, :south)

      # assert_receive_event(MicroWords, ExplorerMoved, fn event, _recorded_event ->
      #   assert event.location == {2, max_y}
      # end)
    end

    test "explorer can create artefact through action", %{world: world, explorer: explorer} do
      action = nil
      assert {:ok, %{} = Worlds.Explorers.make_action(explorer.id, action)
    end
  end
end
