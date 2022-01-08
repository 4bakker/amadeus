import Config

config :exvcr,
  vcr_cassette_library_dir: "fixture/vcr_cassettes",
  custom_cassette_library_dir: "fixture/custom_cassettes",
  filter_sensitive_data: [
    # [pattern: "\"access_token\": \".+\",\n ", placeholder: "ACCESS_TOKEN"],
    [pattern: "client_secret=.+", placeholder: "CLIENT_SECRET"],
    [pattern: "client_id=.+", placeholder: "CLIENT_ID"]
  ],
  filter_url_params: false,
  filter_request_headers: ["Authorization"],
  response_headers_blacklist: []

import_config "#{config_env()}.exs"
import_config "#{config_env()}.secret.exs"

# secret.exs

# config :amadeus,
#   client_id: "",
#   client_secret: ""
