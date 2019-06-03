defmodule IntersectionController.MixProject do
  use Mix.Project

  def project do
    [
      app: :intersection_controller,
      version: "0.1.0",
      elixir: "~> 1.8",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      env: [
        team_numbers: [],
        topics: [
          "/features/lifecycle/simulator/+",
          "/+/+/sensor/+"
        ],
        traffic_model: %{}
      ],
      mod: {IntersectionController.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:certifi, "~> 2.5"},
      {:tortoise, "~> 0.9"}
    ]
  end
end
