defmodule MicroWords.ExplorersTest do
  use MicroWords.DataCase
  import Commanded.Assertions.EventAssertions

  alias MicroWords.Explorers
  alias MicroWords.Explorers.Action
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Rulesets
  alias MicroWords.Worlds
  alias MicroWords.Worlds.Link
  alias MicroWords.Worlds.Location
  alias MicroWords.Worlds.Material

  alias MicroWords.Events.{
    WorldCreated,
    ExplorerEnteredWorld,
    ExplorerAffected,
    ExplorerActionTaken,
    LocationAffected
  }

  describe "common explorer cases" do
    setup do
      explorer_id = Ecto.UUID.generate()
      {:ok, world} = Worlds.create("dev_world", Rulesets.Basic)

      {:ok, %{id: explorer_id} = explorer} = Explorers.enter_world(explorer_id, "dev_world")

      assert_receive_event(MicroWords, WorldCreated, fn event, _recorded_event ->
        assert event.name == "dev_world"
      end)

      assert_receive_event(MicroWords, ExplorerEnteredWorld, fn event, _recorded_event ->
        assert event.world == "dev_world"
        assert event.id == explorer_id
      end)

      {:ok, world: world, explorer: explorer}
    end

    test "explorer can move around correctly", %{world: world, explorer: explorer} do
      [max_x, max_y] = world.ruleset.dimensions()

      assert {:ok, %{location: [^max_x, 1]}, _} = Explorers.take_action(explorer.id, :move_west)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [max_x, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [max_x, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [1, 1]}, _} = Explorers.take_action(explorer.id, :move_east)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [1, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [1, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, 1]}, _} = Explorers.take_action(explorer.id, :move_east)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, 2]}, _} = Explorers.take_action(explorer.id, :move_north)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, 2] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, 2]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, 1]}, _} = Explorers.take_action(explorer.id, :move_south)

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.result.new_location == [2, 1] end,
        fn event, _recorded_event ->
          assert event.action.result.new_location == [2, 1]
          assert event.id == explorer.id
        end
      )

      assert {:ok, %{location: [2, ^max_y]}, _} = Explorers.take_action(explorer.id, :move_south)

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

    test "explorer can create and plant material through action", %{
      world: _world,
      explorer: explorer
    } do
      explorer_id = explorer.id
      content = "Hello MicroWord!"

      assert {:ok, %Explorer{} = explorer, %Action{} = forge_action} =
               Explorers.take_action(explorer.id, :forge_note, %{content: content})

      material_id = forge_action.material_id

      assert forge_action.type == :forge_note
      assert is_binary(material_id)
      assert Enum.count(explorer.materials) == 1
      assert explorer.materials[material_id]

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.type == :forge_note end,
        fn event, _recorded_event ->
          assert event.action == forge_action
        end
      )

      assert {:ok, %Explorer{} = explorer,
              %Action{material_id: ^material_id, type: :plant_material} = plant_action} =
               Explorers.take_action(explorer.id, :plant_material, %{material_id: material_id})

      assert_receive_event(
        MicroWords,
        ExplorerActionTaken,
        fn evt -> evt.action.type == :plant_material end,
        fn event, _recorded_event ->
          assert event.action == plant_action
        end
      )

      assert_receive_event(
        MicroWords,
        LocationAffected,
        fn evt -> evt.action.type == :plant_material end,
        fn event, _recorded_event ->
          passed_plant_action = %{plant_action | progress: :passed}
          assert event.action == passed_plant_action
        end
      )

      assert_receive_event(
        MicroWords,
        ExplorerAffected,
        fn evt -> evt.action.type == :plant_material end,
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
               material: %Material{
                 id: ^material_id,
                 content: "Hello MicroWord!",
                 links: [%Link{type: :originator, id: ^explorer_id}]
               }
             } = location

      {:ok, %{materials: materials_after_placement}} =
        Explorers.enter_world(explorer_id, "dev_world")

      refute materials_after_placement[material_id]
    end
  end
end
