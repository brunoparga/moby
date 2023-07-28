defmodule Moby.MixProject do
  use Mix.Project

  def project do
    [
      app: :moby,
      version: "0.1.1",
      elixir: "~> 1.15",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      dialyzer: [plt_add_apps: [:mix]]
    ]
  end

  def application do
    [
      mod: {Moby.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:dialyxir, "~> 1.3", only: [:dev], runtime: false}
    ]
  end
end
