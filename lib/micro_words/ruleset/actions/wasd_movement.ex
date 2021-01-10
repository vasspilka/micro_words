# defmodule MicroWords.Ruleset.Actions.WasdMovement do
#   use MicroWords.Ruleset.Actions

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
# end
