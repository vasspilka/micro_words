alias MicroWords.Events.{
  ExplorerReceivedRuleset,
  ExplorerActionTaken
}

defimpl Commanded.Event.Upcaster, for: ExplorerReceivedRuleset do
  def upcast(%ExplorerReceivedRuleset{} = event, _metadata) do
    %ExplorerReceivedRuleset{
      event
      | ruleset: String.to_existing_atom(event.ruleset)
    }
  end
end

defimpl Commanded.Event.Upcaster, for: ExplorerActionTaken do
  def upcast(%ExplorerActionTaken{} = event, _metadata) do
    %ExplorerActionTaken{
      event
      | action: event.action
    }
  end
end
