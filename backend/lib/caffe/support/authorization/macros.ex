defmodule Caffe.Authorization.Macros do
  alias Caffe.Authorization.Authorizer

  defmacro authorize(user, do: block) do
    %{function: {action, _}} = __CALLER__

    quote do
      with :ok <- Authorizer.authorize(unquote(action), unquote(user)) do
        unquote(block)
      end
    end
  end
end
