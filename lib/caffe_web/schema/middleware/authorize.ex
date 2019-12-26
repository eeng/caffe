defmodule CaffeWeb.Schema.Middleware.Authorize do
  @behaviour Absinthe.Middleware
  @dialyzer :no_undefined_callbacks

  alias Caffe.Authorization.Authorizer

  def call(%{context: context, arguments: arguments} = resolution, action) do
    with :ok <- Authorizer.authorize(action, context[:current_user], arguments) do
      resolution
    else
      error -> Absinthe.Resolution.put_result(resolution, error)
    end
  end
end
