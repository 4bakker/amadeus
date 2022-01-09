defmodule Amadeus.Client do
  @host "https://test.api.amadeus.com"

  def get_quote(journey, dates, token, finch \\ Req.Finch) do
    [from, to, adults] = journey
    [dep, ret] = dates

    url =
      "#{@host}/v2/shopping/flight-offers?originLocationCode=#{from}&destinationLocationCode=#{to}&departureDate=#{dep}&returnDate=#{ret}&adults=#{adults}&nonStop=true&max=10"

    %Req.Response{status: status, body: body} =
      Req.get!(url,
        headers: [Authorization: "Bearer #{token}"],
        retry: [delay: 500, max_retries: 3],
        finch: finch
      )

    case status do
      200 ->
        min =
          body
          |> get_in(["data", Access.all(), "price", "grandTotal"])
          |> Enum.map(&String.to_float/1)
          |> tap(&(IO.inspect {from, to, &1}))
          |> Enum.min(fn -> "Not available" end)

          [from, to, min]
      _ ->
        IO.inspect(body)
        [from, to, "Request failed"]
    end
  end

  def get_token(id, secret, finch \\ Req.Finch) do
    url = "#{@host}/v1/security/oauth2/token"

    body = {:form, [grant_type: "client_credentials", client_id: id, client_secret: secret]}

    %Req.Response{status: 200, body: body} = Req.post!(url, body, finch: finch)

    body["access_token"]
  end
end
