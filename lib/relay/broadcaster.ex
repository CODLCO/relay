defmodule Relay.Broadcaster do
  require Logger

  alias NostrBasics.{Event}

  alias Relay.Connection.Filters
  alias Relay.Broadcaster.ApplyFilter

  def send(%Event{} = event) do
    for {subscription_id, pid, filter} <- Filters.list() do
      if ApplyFilter.all(event, filter) do
        json = Jason.encode!(["EVENT", filter.subscription_id, event])

        Logger.info("SENDING TO #{inspect(subscription_id)} #{inspect(json)}")

        send(pid, {:emit, json})
      end
    end
  end

  def send_end_of_stored_events(subscription_id) do
    subscriptions =
      Filters.list()
      |> Enum.filter(fn {filter_subscription_id, _pid, _filter} ->
        filter_subscription_id == subscription_id
      end)

    for {pid, _filter} <- subscriptions do
      json = Jason.encode!(["EOSE", subscription_id])

      send(pid, {:emit, json})
    end
  end
end
