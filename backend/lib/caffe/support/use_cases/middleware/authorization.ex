defmodule Caffe.Mediator.Middleware.Authorization do
  alias Caffe.Authorization.Authorizer

  def build(next) do
    fn use_case ->
      case Authorizer.authorize(use_case) do
        :ok -> next.(use_case)
        error -> error
      end
    end
  end
end
