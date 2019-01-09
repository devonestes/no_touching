defmodule Mix.Tasks.Private.Check do
  @moduledoc """
  A mix task to enforce private modules.
  """

  use Mix.Task

  alias NoTouching.Calls

  @recursive true
  @shortdoc "Enforces private functions and modules"

  @switches [
    abort_if_any: :boolean,
    archives_check: :boolean,
    compile: :boolean,
    deps_check: :boolean,
    elixir_version_check: :boolean,
    exclude: :keep,
    format: :string,
    include_siblings: :boolean,
    label: :string,
    only_nodes: :boolean,
    sink: :string,
    source: :string
  ]

  @spec run([binary]) :: any
  def run(args) do
    {opts, _args} = OptionParser.parse!(args, strict: @switches)

    result =
      Calls.calls(opts)
      |> NoTouching.build_graph()
      |> NoTouching.filter_graph()
      |> NoTouching.add_private_info()
      |> NoTouching.analyze()

    case result do
      [] ->
        IO.puts("No private functions called!")

      _ ->
        IO.puts(["Private functions being called:\n\n" | result])
        exit({:shutdown, 1})
    end
  end
end
