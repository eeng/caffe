defmodule Caffe.CommandCase do
  @moduledoc """
  This module defines the setup for tests requiring
  access to the application's command layer.

  You may define functions here to be used as helpers in
  your tests.

  Finally, if the test case interacts with the database,
  it cannot be async. For this reason, every test runs
  inside a transaction which is reset at the beginning
  of the test unless the test case is marked as async.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      alias Caffe.Repo

      import Ecto
      import Ecto.Changeset
      import Ecto.Query
      import Caffe.CommandCase
      import Caffe.Factory
    end
  end

  setup tags do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Caffe.Repo)

    unless tags[:async] do
      Ecto.Adapters.SQL.Sandbox.mode(Caffe.Repo, {:shared, self()})
    end

    :ok
  end

  def errors_on(vex_struct) do
    vex_struct
    |> Vex.errors()
    |> Caffe.Middleware.Validator.merge_errors()
  end

  def has_error_on?(struct, field) do
    struct |> errors_on() |> Map.has_key?(field)
  end
end
