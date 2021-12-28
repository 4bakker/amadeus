defmodule ExVCR.Adapter.FinchTest do
  use ExUnit.Case, async: true
  use ExVCR.Mock, adapter: ExVCR.Adapter.Finch

  setup_all do
    Finch.start_link(name: MyFinch)
    :ok
  end

  test "get token" do
    use_cassette "token" do
      token = Amadeus.Client.get_token("", "", MyFinch)
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
