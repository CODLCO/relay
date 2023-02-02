defmodule Relay.Request do
  alias Relay.Request.SubscriptionRegistry

  def handle(["EVENT", event]) do
    IO.inspect(event, label: "NEW EVENT")

    IO.inspect(SubscriptionRegistry.lookup())
  end

  def handle(["REQ", subscription_id, %{"kinds" => [0]} = query], _peer) do
    IO.inspect(query, label: "#{subscription_id} METADATA EVENT")

    ["EOSE", subscription_id]
  end

  def handle(["REQ", subscription_id, %{"kinds" => [3]} = query] = subscription, _peer) do
    IO.inspect(query, label: "#{subscription_id} CONTACTS EVENT")

    SubscriptionRegistry.subscribe(subscription)

    result = ["EOSE", subscription_id]

    IO.inspect(result, label: "#{subscription_id} RETURNING")
  end

  def handle(["REQ", subscription_id, query], _peer) do
    IO.inspect(query, label: "#{subscription_id} UNKNOWN EVENT")

    ["EOSE", subscription_id]
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
