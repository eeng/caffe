defmodule Caffe.Mediator.Middleware.Init do
  @moduledoc """
  This middleware allows us to modifify the use case before the authorize and execute phases.
  It's used to fetch the record from the DB in use cases that need it for authorization.
  """

  def build(next) do
    fn use_case ->
      case use_case.__struct__.init(use_case) do
        {:ok, initialized_use_case} -> next.(initialized_use_case)
        error -> error
      end
    end
  end
end
