defmodule NoTouching.MixProject do
  use Mix.Project

  def project do
    [
      app: :no_touching,
      version: "0.5.0",
      elixir: "~> 1.7",
      deps: [
        {:ex_doc, "~> 0.19", only: :dev, runtime: false}
      ],
      description: description(),
      package: package(),
      name: "no_touching",
      source_url: "https://github.com/devonestes/no_touching",
      docs: [
        main: "NoTouching",
        extras: ["README.md"]
      ]
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    []
  end

  defp description do
    "A mix task to help you identify if you're using private functions."
  end

  defp package do
    [
      files: ~w(lib mix.exs README.md LICENSE),
      licenses: ["MIT"],
      links: %{"GitHub" => "https://github.com/devonestes/no_touching"}
    ]
  end
end
