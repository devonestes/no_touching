defmodule NoTouching do
  def build_graph(call_data) do
    Enum.reduce(call_data, %{}, fn data, acc ->
      %{callee: callee, caller_module: caller, file: file, line: line} = data

      caller_data = Map.get(acc, caller, %{})
      callee_data = Map.get(caller_data, callee, [])

      new_callee_data = [{file, line} | callee_data]
      new_caller_data = Map.put(caller_data, callee, new_callee_data)

      Map.put(acc, caller, new_caller_data)
    end)
  end

  # These are things that are technically private but called all the time
  # through macro expansions and such. Because of that, we need to ignore these
  # or come up with our own way of detecting function calls.
  @default_ignore [
    {Module, :put_attribute, 4},
    {Kernel.Typespec, :deftypespec, 6},
    {Kernel.LexicalTracker, :read_cache, 2},
    {Protocol, :__derive__, 3},
    {Module, :get_attribute, 3},
    {Kernel.Utils, :defstruct, 2},
    {Kernel.Utils, :announce_struct, 1},
    {ArgumentError, :exception, 1}
  ]

  def filter_graph(graph, path \\ Path.join(File.cwd!(), ".ignore_private")) do
    case File.read(path) do
      {:ok, file} ->
        {list, _} = Code.eval_string(file)
        filter(graph, list ++ @default_ignore)

      _ ->
        filter(graph, @default_ignore)
    end
  end

  def filter(graph, ignore) do
    graph
    |> Enum.map(fn {caller, callees} ->
      {caller, filter_callees(callees, ignore)}
    end)
    |> Map.new()
  end

  def filter_callees(callees, ignore) do
    callees
    |> Enum.reject(&reject_callee?(&1, ignore))
    |> Map.new()
  end

  def reject_callee?({{m, _, _} = callee, _}, ignore) do
    Enum.any?(ignore, fn
      ^callee -> true
      module when is_atom(module) -> inspect(module) == top_level_module(m)
      _ -> false
    end)
  end

  def add_private_info(graph) do
    private =
      Enum.reduce(graph, %{}, fn {caller, callee_data}, acc ->
        acc = add_private_info(caller, acc)

        Enum.reduce(callee_data, acc, fn {{callee, _, _}, _}, acc2 ->
          add_private_info(callee, acc2)
        end)
      end)

    {graph, private}
  end

  defp add_private_info(module, acc) do
    if module in Map.keys(acc) do
      acc
    else
      docs = Code.fetch_docs(module)
      Map.put(acc, module, parse_docs(docs))
    end
  end

  defp parse_docs({:error, _}), do: %{}

  defp parse_docs({_, _, _, _, _, %{private: true}, function_docs}) do
    Enum.reduce(function_docs, %{}, &parse_function(&1, &2, true))
  end

  defp parse_docs({_, _, _, _, :hidden, _, function_docs}) do
    Enum.reduce(function_docs, %{}, &parse_function(&1, &2, true))
  end

  defp parse_docs({_, _, _, _, _, _, function_docs}) do
    [
      {{:function, :db_app_private, 0}, 31, ["db_app_private()"], :none, %{}},
      {{:function, :db_app_public, 0}, 29, ["db_app_public()"], :none, %{}},
      {{:function, :private, 0}, 10, ["private()"], :none, %{}},
      {{:function, :public, 0}, 15, ["public()"], :none, %{private: false}},
      {{:function, :repo_private, 0}, 19, ["repo_private()"], :none, %{}},
      {{:function, :repo_public, 0}, 17, ["repo_public()"], :none, %{}},
      {{:function, :view_private, 0}, 27, ["view_private()"], :none, %{}},
      {{:function, :view_public, 0}, 25, ["view_public()"], :none, %{}},
      {{:function, :web_app_private, 0}, 23, ["web_app_private()"], :none, %{}},
      {{:function, :web_app_public, 0}, 21, ["web_app_public()"], :none, %{}}
    ]

    Enum.reduce(function_docs, %{}, &parse_function(&1, &2, false))
  end

  defp parse_function({{:function, name, arity}, _, _, _, %{private: private?}}, acc, _) do
    Map.put(acc, {name, arity}, private?)
  end

  defp parse_function({{:function, name, arity}, _, _, :hidden, _}, acc, _) do
    Map.put(acc, {name, arity}, true)
  end

  defp parse_function({{:function, name, arity}, _, _, _, _}, acc, module_private?) do
    Map.put(acc, {name, arity}, module_private?)
  end

  defp parse_function(_, acc, _), do: acc

  def analyze({graph, private}) do
    graph
    |> Enum.reduce([], fn {caller, callees}, errors ->
      Enum.reduce(callees, errors, fn {{callee, func, arity}, _} = callee_data, acc ->
        private? = get_in(private, [callee, {func, arity}])
        [errors_for(caller, callee_data, private?) | acc]
      end)
    end)
    |> List.flatten()
  end

  defp errors_for(caller, {{caller, _, _}, _}, _), do: []

  defp errors_for(_, _, nil), do: []

  defp errors_for(caller, {{callee, func, arity}, files_and_lines}, private?) do
    if private? and not (top_level_module(caller) == top_level_module(callee)) do
      error(caller, callee, func, arity, files_and_lines)
    else
      []
    end
  end

  defp error(caller, callee, func, arity, files_and_lines) do
    Enum.map(files_and_lines, fn
      {_, {file, line}} ->
        func = "#{inspect(callee)}.#{func}/#{arity}"
        "  * #{inspect(caller)} called private function #{func} at:\n     #{file}:#{line}\n\n"

      {file, line} ->
        func = "#{inspect(callee)}.#{func}/#{arity}"
        "  * #{inspect(caller)} called private function #{func} at:\n     #{file}:#{line}\n\n"
    end)
  end

  defp top_level_module(module) do
    module
    |> inspect()
    |> String.split(".")
    |> hd()
  end
end
