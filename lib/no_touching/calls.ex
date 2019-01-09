defmodule NoTouching.Calls do
  @doc """
  Everything here is taken from mix xref - thanks Elixir team!

  Try not to touch this because it's not unit tested, really important, and
  very complex. Also, don't add anything here so we know what's ours and what
  isn't.
  """

  @manifest "compile.elixir"

  require Mix.Compilers.Elixir
  alias Mix.Compilers.Elixir, as: Compiler

  def calls(opts \\ []) do
    module_sources =
      for manifest <- manifests(opts),
          manifest_data = Compiler.read_manifest(manifest, ""),
          Compiler.module(module: module, sources: sources) <- manifest_data,
          source <- sources,
          source = Enum.find(manifest_data, &match?(Compiler.source(source: ^source), &1)),
          do: {module, source}

    Enum.flat_map(module_sources, fn {caller_module, source} ->
      Compiler.source(
        runtime_dispatches: runtime_nested,
        compile_dispatches: compile_nested,
        source: rel_file
      ) = source

      runtime_function_calls =
        dispatches_to_function_calls(caller_module, rel_file, runtime_nested)

      compile_function_calls =
        dispatches_to_function_calls(caller_module, rel_file, compile_nested)

      runtime_function_calls ++ compile_function_calls
    end)
  end

  defp dispatches_to_function_calls(caller_module, file, dispatches) do
    for {module, function_calls} <- dispatches,
        {{function, arity}, lines} <- function_calls,
        line <- lines do
      %{
        callee: {module, function, arity},
        file: file,
        line: line,
        caller_module: caller_module
      }
    end
  end

  defp manifests(opts) do
    siblings =
      if opts[:include_siblings] do
        for %{scm: Mix.SCM.Path, opts: opts} <- Mix.Dep.cached(),
            opts[:in_umbrella],
            do: Path.join([opts[:build], ".mix", @manifest])
      else
        []
      end

    [Path.join(Mix.Project.manifest_path(), @manifest) | siblings]
  end
end
