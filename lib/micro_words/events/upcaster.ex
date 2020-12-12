# alias MicroWords.Action

# alias MicroWords.Events.{
#   ExplorerReceivedRuleset,
#   ExplorerActionTaken
# }

# defimpl Commanded.Event.Upcaster, for: ExplorerReceivedRuleset do
#   def upcast(%ExplorerReceivedRuleset{} = event, _metadata) do
#     ruleset =
#       case event.ruleset do
#         ruleset when is_binary(ruleset) -> String.to_existing_atom(event.ruleset)
#         ruleset when is_atom(ruleset) -> ruleset
#         _ -> raise "Invalid ruleset"
#       end

#     %ExplorerReceivedRuleset{
#       event
#       | ruleset: ruleset
#     }
#   end
# end

# defimpl Commanded.Event.Upcaster, for: ExplorerActionTaken do
#   def upcast(%ExplorerActionTaken{} = event, _metadata) do
#     action =
#       event.action
#       |> Map.put(:type, String.to_existing_atom(event.action.type))
#       |> Map.put(:ruleset, String.to_existing_atom(event.action.ruleset))
#       |> Map.put(:progress, String.to_existing_atom(event.action.progress))

#     %ExplorerActionTaken{
#       event
#       | action: struct(Action, action)
#     }
#   end
# end
