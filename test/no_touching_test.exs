defmodule NoTouchingTest do
  use ExUnit.Case, async: true

  @call_data [
    %{
      callee: {DBApp, :private, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 37
    },
    %{
      callee: {Module, :put_attribute, 4},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 37
    },
    %{
      callee: {DBApp, :private, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 42
    },
    %{
      callee: {DBApp, :public, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 35
    },
    %{
      callee: {DBApp.Repo, :private, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 25
    },
    %{
      callee: {DBApp.Repo, :public, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 23
    },
    %{
      callee: {WebApp, :private, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 29
    },
    %{
      callee: {WebApp, :public, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 27
    },
    %{
      callee: {WebApp.View, :private, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 33
    },
    %{
      callee: {WebApp.View, :public, 0},
      caller_module: WebApp,
      file: "support/web_app.ex",
      line: 31
    },
    %{
      callee: {DBApp, :private, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 26
    },
    %{
      callee: {DBApp, :public, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 24
    },
    %{
      callee: {DBApp.Repo, :private, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 14
    },
    %{
      callee: {DBApp.Repo, :public, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 12
    },
    %{
      callee: {WebApp, :private, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 18
    },
    %{
      callee: {WebApp, :public, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 16
    },
    %{
      callee: {WebApp.View, :private, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 22
    },
    %{
      callee: {WebApp.View, :public, 0},
      caller_module: WebApp.View,
      file: "support/web_app/view.ex",
      line: 20
    },
    %{
      callee: {DBApp, :private, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 31
    },
    %{
      callee: {DBApp, :public, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 29
    },
    %{
      callee: {DBApp.Repo, :private, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 19
    },
    %{
      callee: {DBApp.Repo, :public, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 17
    },
    %{
      callee: {WebApp, :private, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 23
    },
    %{
      callee: {WebApp, :public, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 21
    },
    %{
      callee: {WebApp.View, :private, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 27
    },
    %{
      callee: {WebApp.View, :public, 0},
      caller_module: DBApp,
      file: "support/db_app.ex",
      line: 25
    },
    %{
      callee: {DBApp, :private, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 30
    },
    %{
      callee: {DBApp, :public, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 28
    },
    %{
      callee: {DBApp.Repo, :private, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 18
    },
    %{
      callee: {DBApp.Repo, :public, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 16
    },
    %{
      callee: {WebApp, :private, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 22
    },
    %{
      callee: {WebApp, :public, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 20
    },
    %{
      callee: {WebApp.View, :private, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 26
    },
    %{
      callee: {WebApp.View, :public, 0},
      caller_module: DBApp.Repo,
      file: "support/db_app/repo.ex",
      line: 24
    }
  ]

  @graph %{
    DBApp => %{
      {DBApp, :private, 0} => [{"support/db_app.ex", 31}],
      {DBApp, :public, 0} => [{"support/db_app.ex", 29}],
      {DBApp.Repo, :private, 0} => [{"support/db_app.ex", 19}],
      {DBApp.Repo, :public, 0} => [{"support/db_app.ex", 17}],
      {WebApp, :private, 0} => [{"support/db_app.ex", 23}],
      {WebApp, :public, 0} => [{"support/db_app.ex", 21}],
      {WebApp.View, :private, 0} => [{"support/db_app.ex", 27}],
      {WebApp.View, :public, 0} => [{"support/db_app.ex", 25}]
    },
    DBApp.Repo => %{
      {DBApp, :private, 0} => [{"support/db_app/repo.ex", 30}],
      {DBApp, :public, 0} => [{"support/db_app/repo.ex", 28}],
      {DBApp.Repo, :private, 0} => [{"support/db_app/repo.ex", 18}],
      {DBApp.Repo, :public, 0} => [{"support/db_app/repo.ex", 16}],
      {WebApp, :private, 0} => [{"support/db_app/repo.ex", 22}],
      {WebApp, :public, 0} => [{"support/db_app/repo.ex", 20}],
      {WebApp.View, :private, 0} => [{"support/db_app/repo.ex", 26}],
      {WebApp.View, :public, 0} => [{"support/db_app/repo.ex", 24}]
    },
    WebApp.View => %{
      {DBApp, :private, 0} => [{"support/web_app/view.ex", 26}],
      {DBApp, :public, 0} => [{"support/web_app/view.ex", 24}],
      {DBApp.Repo, :private, 0} => [{"support/web_app/view.ex", 14}],
      {DBApp.Repo, :public, 0} => [{"support/web_app/view.ex", 12}],
      {WebApp, :private, 0} => [{"support/web_app/view.ex", 18}],
      {WebApp, :public, 0} => [{"support/web_app/view.ex", 16}],
      {WebApp.View, :private, 0} => [{"support/web_app/view.ex", 22}],
      {WebApp.View, :public, 0} => [{"support/web_app/view.ex", 20}]
    },
    WebApp => %{
      {DBApp, :public, 0} => [{"support/web_app.ex", 35}],
      {Module, :put_attribute, 4} => [{"support/web_app.ex", 37}],
      {DBApp.Repo, :private, 0} => [{"support/web_app.ex", 25}],
      {DBApp.Repo, :public, 0} => [{"support/web_app.ex", 23}],
      {WebApp, :private, 0} => [{"support/web_app.ex", 29}],
      {WebApp, :public, 0} => [{"support/web_app.ex", 27}],
      {WebApp.View, :private, 0} => [{"support/web_app.ex", 33}],
      {WebApp.View, :public, 0} => [{"support/web_app.ex", 31}],
      {DBApp, :private, 0} => [{"support/web_app.ex", 42}, {"support/web_app.ex", 37}]
    }
  }

  @filtered %{
    DBApp => %{
      {DBApp, :private, 0} => [{"support/db_app.ex", 31}],
      {DBApp, :public, 0} => [{"support/db_app.ex", 29}],
      {DBApp.Repo, :private, 0} => [{"support/db_app.ex", 19}],
      {DBApp.Repo, :public, 0} => [{"support/db_app.ex", 17}],
      {WebApp, :private, 0} => [{"support/db_app.ex", 23}],
      {WebApp, :public, 0} => [{"support/db_app.ex", 21}],
      {WebApp.View, :private, 0} => [{"support/db_app.ex", 27}],
      {WebApp.View, :public, 0} => [{"support/db_app.ex", 25}]
    },
    DBApp.Repo => %{
      {DBApp, :private, 0} => [{"support/db_app/repo.ex", 30}],
      {DBApp, :public, 0} => [{"support/db_app/repo.ex", 28}],
      {DBApp.Repo, :private, 0} => [{"support/db_app/repo.ex", 18}],
      {DBApp.Repo, :public, 0} => [{"support/db_app/repo.ex", 16}],
      {WebApp, :private, 0} => [{"support/db_app/repo.ex", 22}],
      {WebApp, :public, 0} => [{"support/db_app/repo.ex", 20}],
      {WebApp.View, :private, 0} => [{"support/db_app/repo.ex", 26}],
      {WebApp.View, :public, 0} => [{"support/db_app/repo.ex", 24}]
    },
    WebApp.View => %{
      {DBApp, :private, 0} => [{"support/web_app/view.ex", 26}],
      {DBApp, :public, 0} => [{"support/web_app/view.ex", 24}],
      {DBApp.Repo, :private, 0} => [{"support/web_app/view.ex", 14}],
      {DBApp.Repo, :public, 0} => [{"support/web_app/view.ex", 12}],
      {WebApp, :private, 0} => [{"support/web_app/view.ex", 18}],
      {WebApp, :public, 0} => [{"support/web_app/view.ex", 16}],
      {WebApp.View, :private, 0} => [{"support/web_app/view.ex", 22}],
      {WebApp.View, :public, 0} => [{"support/web_app/view.ex", 20}]
    },
    WebApp => %{
      {DBApp, :public, 0} => [{"support/web_app.ex", 35}],
      {DBApp.Repo, :private, 0} => [{"support/web_app.ex", 25}],
      {DBApp.Repo, :public, 0} => [{"support/web_app.ex", 23}],
      {WebApp, :private, 0} => [{"support/web_app.ex", 29}],
      {WebApp, :public, 0} => [{"support/web_app.ex", 27}],
      {WebApp.View, :private, 0} => [{"support/web_app.ex", 33}],
      {WebApp.View, :public, 0} => [{"support/web_app.ex", 31}],
      {DBApp, :private, 0} => [{"support/web_app.ex", 42}, {"support/web_app.ex", 37}]
    }
  }

  @with_private_info {@filtered,
                      %{
                        DBApp => %{
                          {:db_app_private, 0} => true,
                          {:db_app_public, 0} => true,
                          {:private, 0} => true,
                          {:public, 0} => false,
                          {:repo_private, 0} => true,
                          {:repo_public, 0} => true,
                          {:view_private, 0} => true,
                          {:view_public, 0} => true,
                          {:web_app_private, 0} => true,
                          {:web_app_public, 0} => true
                        },
                        DBApp.Repo => %{
                          {:db_app_private, 0} => false,
                          {:db_app_public, 0} => false,
                          {:private, 0} => true,
                          {:public, 0} => false,
                          {:repo_private, 0} => false,
                          {:repo_public, 0} => false,
                          {:view_private, 0} => false,
                          {:view_public, 0} => false,
                          {:web_app_private, 0} => false,
                          {:web_app_public, 0} => false
                        },
                        WebApp => %{
                          {:db_app_private, 0} => false,
                          {:db_app_public, 0} => false,
                          {:private, 0} => true,
                          {:public, 0} => false,
                          {:repo_private, 0} => false,
                          {:repo_public, 0} => false,
                          {:view_private, 0} => false,
                          {:view_public, 0} => false,
                          {:view_public_2, 0} => false,
                          {:web_app_private, 0} => false,
                          {:web_app_public, 0} => false
                        },
                        WebApp.View => %{
                          {:db_app_private, 0} => true,
                          {:db_app_public, 0} => true,
                          {:private, 0} => true,
                          {:public, 0} => false,
                          {:repo_private, 0} => true,
                          {:repo_public, 0} => true,
                          {:view_private, 0} => true,
                          {:view_public, 0} => true,
                          {:web_app_private, 0} => true,
                          {:web_app_public, 0} => true
                        }
                      }}

  @errors [
    "  * WebApp.View called private function DBApp.Repo.private/0 at:\n     support/web_app/view.ex:14\n\n",
    "  * WebApp.View called private function DBApp.private/0 at:\n     support/web_app/view.ex:26\n\n",
    "  * WebApp called private function DBApp.Repo.private/0 at:\n     support/web_app.ex:25\n\n",
    "  * WebApp called private function DBApp.private/0 at:\n     support/web_app.ex:42\n\n",
    "  * WebApp called private function DBApp.private/0 at:\n     support/web_app.ex:37\n\n",
    "  * DBApp.Repo called private function WebApp.View.private/0 at:\n     support/db_app/repo.ex:26\n\n",
    "  * DBApp.Repo called private function WebApp.private/0 at:\n     support/db_app/repo.ex:22\n\n",
    "  * DBApp called private function WebApp.View.private/0 at:\n     support/db_app.ex:27\n\n",
    "  * DBApp called private function WebApp.private/0 at:\n     support/db_app.ex:23\n\n"
  ]

  describe "build_graph/1" do
    test "reduces call data down to a call graph" do
      assert NoTouching.build_graph(@call_data) == @graph
    end
  end

  describe "filter_graph/1" do
    test "removes stuff we want to ignore" do
      assert NoTouching.filter_graph(@graph) == @filtered
    end
  end

  describe "add_private_info/1" do
    test "fetches docs for all callers and callees and adds them to the graph" do
      assert NoTouching.add_private_info(@filtered) == @with_private_info
    end
  end

  describe "analyze/1" do
    test "return the correct errors" do
      assert NoTouching.analyze(@with_private_info) == @errors
    end
  end
end
