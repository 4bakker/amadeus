import Config

config :exvcr, [
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_sensitive_data: [
    [pattern: "\"client-secret\": ", placeholder: "SECRET_PLACEHOLDER"]
  ],
  filter_url_params: false,
  filter_request_headers: [],
  response_headers_blacklist: []
]

config :amadeus,
  client_id: "",
  client_secret: ""

import_config "#{config_env()}.exs"
import_config "#{config_env()}.secret.exs"
