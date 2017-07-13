use Mix.Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :video_grafikart, VideoGrafikart.Endpoint,
  http: [port: 4001],
  server: false

# Print only warnings and errors during test
config :logger, level: :warn

config :video_grafikart, :video_path, "test/data/"

config :video_grafikart, :vidme,
  access_token: "XXXXXXXXXXX"

config :video_grafikart, :paths,
  video: "test/data/",
  thumbnail: "test/data/"

config :video_grafikart, VideoGrafikart.Repo,
  adapter: Ecto.Adapters.MySQL,
  username: "root",
  password: "root",
  database: "grafikart_dev",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
