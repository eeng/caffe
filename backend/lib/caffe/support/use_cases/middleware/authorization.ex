defmodule Caffe.Mediator.Middleware.Authorization do
  alias Caffe.Authorization.Authorizer

  def build(next) do
    fn use_case ->
      if use_case.__struct__.skip_authorization do
        next.(use_case)
      else
        case Authorizer.authorize(use_case) do
          :ok -> next.(use_case)
          error -> error
        end
      end
    end
  end
end
