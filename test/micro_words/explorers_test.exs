defmodule MicroWords.ExplorersTest do
  use MicroWords.DataCase
  import Commanded.Assertions.EventAssertions

  alias MicroWords.Artefact
  alias MicroWords.Explorers
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Action
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Location

  alias MicroWords.Events.{
    WorldCreated,
    ExplorerEnteredWorld,
    ExplorerReceivedRuleset,
    ExplorerAffected,
    ExplorerActionTaken,
    LocationAffected
  }

  describe "common explorer cases" do
    setup do
      explorer_id = UUID.uuid4()
      {:ok, world} = Worlds.create("dev_world")
      {:ok, %{id: ^explorer_id} = explorer} = Explorers.enter_world(explorer_id, "dev_world")

      assert_receive_event(MicroWords, WorldCreated, fn event, _recorded_event ->
        assert event.name == "dev_world"
      end)

      assert_receive_event(MicroWords, ExplorerEnteredWorld, fn event, _recorded_event ->
        assert event.world == "dev_world"
        assert event.id == explorer_id
      end)

      assert_receive_event(MicroWords, ExplorerReceivedRuleset, fn event, _recorded_event ->
        assert event.ruleset == world.ruleset
      end)

      {:ok, world: world, explorer: explorer}
    end

    test "explorer can move around correctly", %{world: world, explorer: explorer} do
      [max_x, max_y] = world.ruleset.dimensions()

      assert {:ok, %{location: [^max_x, 1]}, _} = Explorers.make_action(explorer.id, :move_west)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [max_x, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [max_x, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [1, 1]}, _} = Explorers.make_action(explorer.id, :move_east)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [1, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [1, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, 1]}, _} = Explorers.make_action(explorer.id, :move_east)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, 2]}, _} = Explorers.make_action(explorer.id, :move_north)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, 2] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, 2]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, 1]}, _} = Explorers.make_action(explorer.id, :move_south)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, ^max_y]}, _} = Explorers.make_action(explorer.id, :move_south)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, max_y] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, max_y]
          assert event.id == explorer.id
        end
      )
    end

    test "explorer can create and plant artefact through action", %{
      world: _world,
      explorer: explorer
    } do
      explorer_id = explorer.id
      content = "Hello MicroWord!"

      assert {:ok, %Explorer{} = explorer, %Action{} = forge_action} =
               Explorers.make_action(explorer.id, :forge_note, %{content: content})

      artefact_id = forge_action.artefact_id

      assert forge_action.type == :forge_note
      assert is_binary(artefact_id)
      assert Enum.count(explorer.artefacts) == 1
      assert explorer.artefacts[artefact_id]

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.type == :forge_note end,
        fn event, _recorded_event ->
          assert event.action == forge_action
        end
      )

      assert {:ok, %Explorer{} = explorer,
              %Action{artefact_id: ^artefact_id, type: :plant_artefact} = plant_action} =
               Explorers.make_action(explorer.id, :plant_artefact, forge_action)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.type == :plant_artefact end,
        fn event, _recorded_event ->
          assert event.action == plant_action
        end
      )

      assert_receive_event(
        MicroWords,
        LocationAffected,
        fn evt -> evt.action.type == :plant_artefact end,
        fn event, _recorded_event ->
          passed_plant_action = %{plant_action | progress: :passed}
          assert event.action == passed_plant_action
        end
      )

      assert_receive_event(
        MicroWords,
        ExplorerAffected,
        fn evt -> evt.action.type == :plant_artefact end,
        fn event, _recorded_event ->
          passed_plant_action = %{plant_action | progress: :passed}
          assert event.action == passed_plant_action
        end
      )

      {:ok, location} =
        explorer
        |> Location.id_from_attrs()
        |> Worlds.get_location()

      assert %Location{
               artefact: %Artefact{
                 id: ^artefact_id,
                 content: "Hello MicroWord!",
                 originator: ^explorer_id
               }
             } = location

      {:ok, %{artefacts: artefacts_after_placement}} =
        Explorers.enter_world(explorer_id, "dev_world")

      refute artefacts_after_placement[artefact_id]
    end
  end
end
