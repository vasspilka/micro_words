defmodule MicroWords.Ruleset.Actions.WasdMovement do
  alias MicroWords.Action
  alias MicroWords.Explorers.Explorer
  alias MicroWords.Ruleset.ActionDefinition

  defmodule MoveNorth do
    use ActionDefinition, %ActionDefinition{
      name: :move_north,
      type: :movement,
      base_cost: 0,
      description: "Move up by one.",
      key_binding: "w"
    }

    def on_build(%Explorer{} = o, %{}) do
      [_max_x, max_y] = o.ruleset.dimensions()
      %{location: [current_x, current_y]} = o

      y = if current_y == max_y, do: 1, else: current_y + 1

      [result: %{new_location: [current_x, y]}]
    end

    def on_action_taken(%Explorer{}, %Action{} = act) do
      [location: act.result.new_location]
    end
  end

  defmodule MoveEast do
    use ActionDefinition, %ActionDefinition{
      name: :move_east,
      type: :movement,
      base_cost: 0,
      description: "Move right by one.",
      key_binding: "d"
    }

    def on_build(%Explorer{} = o, %{}) do
      [max_x, _max_y] = o.ruleset.dimensions()
      %{location: [current_x, current_y]} = o

      x = if current_x == max_x, do: 1, else: current_x + 1

      [result: %{new_location: [x, current_y]}]
    end

    def on_action_taken(%Explorer{}, act) do
      [location: act.result.new_location]
    end
  end

  defmodule MoveSouth do
    use ActionDefinition, %ActionDefinition{
      name: :move_south,
      type: :movement,
      base_cost: 0,
      description: "Move down by one.",
      key_binding: "s"
    }

    def on_build(%Explorer{} = o, %{}) do
      [_max_x, max_y] = o.ruleset.dimensions()
      %{location: [current_x, current_y]} = o

      y = if current_y == 1, do: max_y, else: current_y - 1

      [result: %{new_location: [current_x, y]}]
    end

    def on_action_taken(%Explorer{}, %Action{} = act) do
      [location: act.result.new_location]
    end
  end

  defmodule MoveWest do
    use ActionDefinition, %ActionDefinition{
      name: :move_west,
      type: :movement,
      base_cost: 0,
      description: "Move left by one.",
      key_binding: "a"
    }

    def on_build(%Explorer{} = o, %{}) do
      [max_x, _max_y] = o.ruleset.dimensions()
      %{location: [current_x, current_y]} = o

      x = if current_x == 1, do: max_x, else: current_x - 1

      [result: %{new_location: [x, current_y]}]
    end

    def on_action_taken(%Explorer{}, act) do
      [location: act.result.new_location]
    end
  end

  #   defaction :wasd_move,
  #     cost: 0,
  #     data: %{direction: :atom},
  #     result: %{new_location: {:array, :integer}} do
  #     on_build(fn _exlorer, _action ->
  #       %{location: [current_x, current_y]} = explorer
  #       [max_x, max_y] = explorer.ruleset.dimensions()

  #       x =
  #         case {current_x, direction} do
  #           {_, direction} when direction in [:north, :south] -> current_x
  #           {1, :west} -> max_x
  #           {_, :west} -> current_x - 1
  #           {^max_x, :east} -> 1
  #           {_, :east} -> current_x + 1
  #         end

  #       y =
  #         case {current_y, direction} do
  #           {_, direction} when direction in [:east, :west] -> current_y
  #           {^max_y, :north} -> 1
  #           {_, :north} -> current_y + 1
  #           {1, :south} -> max_y
  #           {_, :south} -> current_y - 1
  #         end

  #       [result: %{new_location: [x, y]}]
  #     end)

  #     on_action_taken(fn exlorer, action ->
  #       [location: action.result.new_location]
  #     end)
  #   end
end
