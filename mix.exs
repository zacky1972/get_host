defmodule GetHost.MixProject do
  use Mix.Project

  @source_url "https://github.com/zacky1972/get_host"

  def project do
    [
      app: :get_host,
      version: "1.0.0",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),

      # Docs
      name: "GetHost",
      source_url: @source_url,
      docs: &docs/0,

      # Hex
      description: description(),
      package: package()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      # {:dep_from_hexpm, "~> 0.3.0"},
      # {:dep_from_git, git: "https://github.com/elixir-lang/my_dep.git", tag: "0.1.0"}
      {:credo, "~> 1.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34", only: :dev, runtime: false, warn_if_outdated: true}
    ]
  end

  defp docs do
    [
      main: "GetHost",
      extras: ["README.md", "LICENSE"]
    ]
  end

  defp description do
    "GetHost: A cross-platform Elixir library for retrieving the fully qualified hostname of a system."
  end

  defp package do
    [
      licenses: ["Apache-2.0"],
      links: %{"GitHub" => @source_url}
    ]
  end
end
