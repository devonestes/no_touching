defmodule WebApp do
  @moduledoc """
  A moduledoc for WebApp.

  This is public since it's a top level module.
  """

  @doc """
  a doc string for private/0

  This is private because it's annotated
  """
  @doc private: true
  def private(), do: nil

  @doc """
  a doc string for public/0

  This is public because it's not annotated and in a public module
  """
  def public(), do: nil

  def repo_public(), do: DBApp.Repo.public()

  def repo_private(), do: DBApp.Repo.private()

  def web_app_public(), do: WebApp.public()

  def web_app_private(), do: WebApp.private()

  def view_public(), do: WebApp.View.public()

  def view_public_2(), do: WebApp.View.public()

  def view_private(), do: WebApp.View.private()

  def db_app_public, do: DBApp.public()

  def db_app_private, do: DBApp.private()
end
