# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

# Configures the endpoint
config :video_grafikart, VideoGrafikart.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "FRGWKSSHeLhCB306slEWX7W7abABIFIYftMoYcN5G9sCn5a01/MIUQuO8qJ7eKqN",
  render_errors: [view: VideoGrafikart.ErrorView, accepts: ~w(html json)],
  pubsub: [name: VideoGrafikart.PubSub,
           adapter: Phoenix.PubSub.PG2]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

config :toniq, retry_strategy: VideoGrafikart.RetryOnce

config :guardian, Guardian,
  allowed_algos: ["HS256"], # optional
  verify_module: VideoGrafikart.Guardian.ClaimValidation,  # optional
  issuer: "Grafikart",
  ttl: { 1, :days },
  allowed_drift: 2000,
  verify_issuer: true,
  secret_key: System.get_env("JWT_SECRET") || "secret",
  serializer: VideoGrafikart.GuardianSerializer

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env}.exs"
