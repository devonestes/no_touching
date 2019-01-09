# No Touching!

![no_touching](https://user-images.githubusercontent.com/8422484/50927634-a4702000-1458-11e9-8a64-20462fe9391a.gif)

A mix task to let you know if you're using private modules or functions.

Run the task with `mix private.check`.

If you are calling a private function in a different application (as defined by
the top level module for that application), then the mix task will fail.

A top level module is something like `MyApp` or `Ecto` or `Enum`. Any modules
within that namespace are allowed to call any private functions in any other
modules in that namespace.

For example, `MyApp.Users` can call private functions on `MyApp.Repo` because
they have the same top level module - `MyApp`. But `MyAppWeb.UserController`
cannot call any private functions on `MyApp.Users` because they have different
top level modules `MyAppWeb` vs `MyApp`.

A function is private if:

  1) The function has `@doc false`
  2) The function is in a module with `@moduledoc false`
  3) The function or module is annotated with `@doc private: true`

If you want to make a single function in a private module be public, you can add
`@doc private: false` to that function.

This runs recursively in umbrella projects.

## Installation

Add `no_touching` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [{:no_touching, "~> 0.1", only: [:dev, :test]}]
end
```

## Current issues

There are a lot of private functions that are currently shown as called because
of macro expansion. Some of the really common ones are ignored directly in this
library. Others, you can ignore by adding to your `.ignore_private` file.

In time I'm hoping to make this better, but for now adding things to
`.ignore_private` is a good workaround.

## Ignoring things

If you are seeing things that are coming up as being called but you want to
ignore them, you can add an entry to a `.ignore_private` file in the root of
your project. The file looks like this:

```
[
  {MyApp.Users, :private_fun, 2},
  Ecto,
  Absinthe
]
```

If you add a `{module, function, arity}` tuple to the list, any calls to that
private function will be ignored. If you add just a single top level module to
the list, all calls to any private functions in that namespace will be ignored.
This is really handy for ignoring things like all private functions in `Ecto`
that appear to be called because of macro expansion.
