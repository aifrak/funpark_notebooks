defmodule FunPark.MixProject do
  use Mix.Project

  def project do
    [
      app: :fun_park,
      version: "0.1.0",
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      aliases: aliases()
    ]
  end

  def application do
    [
      extra_applications: [:logger, :observer, :wx, :runtime_tools]
    ]
  end

  defp deps do
    []
  end

  defp aliases do
    [
      restart: ["clean", "compile"]
    ]
  end
end
