import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :moby_web, MobyWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "QwIVPypJtgKbUPYgAiM28F9orXO42OLo/onS2pagX5aRxoZDC8AqEqRKMT3dBPRl",
  server: false

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
