import Config

ipstack_api_key =
  System.get_env("IPSTACK_API_KEY") ||
    raise """
    environment variable IPSTACK_API_KEY is missing.
    Get a free key: https://ipstack.com/signup/free
    """

config :geoip,
  provider: :ipstack,
  api_key: ipstack_api_key,
  use_https: false

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :locator, LocatorWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base,
  server: true
