defmodule DBApp.Repo do
  @moduledoc """
  A moduledoc for DBApp.Repo

  This is public because it's annotated
  """
  @doc private: false

  # Private because it's annotated
  @doc private: true
  def private(), do: nil

  # Public because it's in a public module
  def public(), do: nil

  def repo_public(), do: DBApp.Repo.public()

  def repo_private(), do: DBApp.Repo.private()

  def web_app_public(), do: WebApp.public()

  def web_app_private(), do: WebApp.private()

  def view_public(), do: WebApp.View.public()

  def view_private(), do: WebApp.View.private()

  def db_app_public, do: DBApp.public()

  def db_app_private, do: DBApp.private()
end
