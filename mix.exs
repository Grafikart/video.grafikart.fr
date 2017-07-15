defmodule VideoGrafikart.Mixfile do
  use Mix.Project

  def project do
    [
      app: :video_grafikart,
      version: "0.0.1",
      elixir: ">= 1.3.0",
      elixirc_paths: elixirc_paths(Mix.env),
      compilers: [:phoenix, :gettext] ++ Mix.compilers,
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      test_coverage: [tool: ExCoveralls],
      deps: deps()]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [
      mod: {VideoGrafikart, []},
      applications: [
        :phoenix,
        :phoenix_pubsub,
        :phoenix_html,
        :cowboy,
        :phoenix_ecto,
        :logger,
        :gettext,
        :guardian,
        :httpoison,
        :poison,
        :mariaex,
        :toniq,
        :logger_file_backend
      ]
    ]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:logger_file_backend, "~> 0.0.10"},
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_html, "~> 2.6"},
      {:phoenix_ecto, "~> 3.0"},
      {:mariaex, ">= 0.0.0"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:gettext, "~> 0.11"},
      {:cowboy, "~> 1.0"},
      {:guardian, "~> 0.14"},
      {:distillery, "~> 1.1"},
      {:mix_test_watch, "~> 0.2", only: :dev},
      {:httpoison, "~> 0.12.0"},
      {:toniq, "~> 1.2"},
      {:excoveralls, github: "parroty/excoveralls"}
   ]
  end
end
