import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :website, WebsiteWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "hPyPx6CCrKimSM6wsQQoZT1g8g7hWmNaQADVAq6x6aj80KP412kt0sHIuW0LRclF",
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
