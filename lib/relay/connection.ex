defmodule Relay.Connection do
  alias Relay.Connection.{SubscriptionRegistry}
  alias Relay.Connection.Commands.{Request}

  def handle(["EVENT", event]) do
    IO.inspect(event, label: "NEW EVENT")

    IO.inspect(SubscriptionRegistry.lookup())
  end

  def handle(["REQ" | request], _peer) do
    Request.handle(request)
  end

  def handle(["CLOSE", subscription_id], _peer) do
    IO.inspect(subscription_id, label: "CLOSE COMMAND")

    []
  end

  def handle(unknown, _peer) do
    IO.inspect(unknown, label: "UNKNOWN COMMAND")

    []
  end

  def terminate(peer) do
    IO.inspect(peer, label: "TERMINATE in Relay.Request")
  end
end
