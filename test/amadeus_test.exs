defmodule ExVCR.Adapter.FinchTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  setup_all do
    Finch.start_link(name: MyFinch)
    :ok
  end

  test "get token" do
    use_cassette "token" do
      client_id = Application.fetch_env!(:amadeus, :client_id)
      client_secret = Application.fetch_env!(:amadeus, :client_secret)
      _token = Amadeus.Client.get_token(client_id, client_secret, MyFinch)
    end
  end

  test "get quotes" do
    use_cassette "quotes" do
      client_id = Application.fetch_env!(:amadeus, :client_id)
      client_secret = Application.fetch_env!(:amadeus, :client_secret)
      token = Amadeus.Client.get_token(client_id, client_secret, MyFinch)

      journey = ["AMS", "BCN", 2]
      dates = [Date.utc_today |> Date.add(2) |> Date.to_string, Date.utc_today |> Date.add(4) |> Date.to_string]
      Amadeus.Client.get_quote(journey, dates, token, MyFinch)

      journey = ["BCN", "AMS", 3]
      dates = [Date.utc_today |> Date.add(2) |> Date.to_string, Date.utc_today |> Date.add(4) |> Date.to_string]
      Amadeus.Client.get_quote(journey, dates, token, MyFinch)
    end
  end

  test "get cheapest option" do
    use_cassette "cheapest" do
      location_people = %{"AMS" => 3, "BCN" => 1, "LHR" => 2}
      dates = [Date.utc_today |> Date.add(2) |> Date.to_string, Date.utc_today |> Date.add(4) |> Date.to_string]
      Amadeus.Agent.get_cheapest_location(location_people, dates)
    end
  end

  test "get request" do
    use_cassette "example_finch_request" do
      {:ok, response} = Finch.build(:get, "http://example.com/") |> Finch.request(MyFinch)
      assert response.status == 200
      assert Map.new(response.headers)["content-type"] == "text/html; charset=UTF-8"
      assert response.body =~ ~r/Example Domain/
    end
  end
end
