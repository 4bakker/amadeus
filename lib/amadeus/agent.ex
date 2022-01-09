defmodule Amadeus.Agent do
  alias Amadeus.Client

  def get_cheapest_location(locations_people, dates) do
    locations = Map.keys(locations_people)
    journeys = for f <- locations, t <- locations, f != t, do: [f, t, locations_people[f]]
    IO.inspect journeys
    journeys
    |> get_location_quotes(dates)
    |> find_cheapest_location()
  end

  def get_location_quotes(journeys, dates) do
    client_id = Application.fetch_env!(:amadeus, :client_id)
    client_secret = Application.fetch_env!(:amadeus, :client_secret)
    token = Client.get_token(client_id, client_secret)

    journeys
    |> Task.async_stream(&Client.get_quote(&1, dates, token), max_concurrency: 12)
    |> Enum.into([], fn {:ok, res} -> res end)
  end

  def find_cheapest_location(quotes) do
    IO.inspect quotes
    quotes
    |> Enum.group_by(&Enum.at(&1, 1), &Enum.at(&1, 2))
    |> Enum.filter(fn {_k, v} -> Enum.all?(v, &is_float/1) end)
    |> Enum.map(fn {k, v} -> %{k => Float.round(Enum.sum(v), 2)} end)
    |> Enum.min_by(&Map.values/1)
  end
end
