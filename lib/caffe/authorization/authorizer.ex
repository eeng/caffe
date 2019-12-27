defmodule Caffe.Authorization.Authorizer do
  alias Caffe.Authorization.Policies.{AccountsPolicy, MenuPolicy, OrderingPolicy}

  @policies [AccountsPolicy, MenuPolicy, OrderingPolicy]

  defmodule Policy do
    @callback actions() :: list(atom)
    @callback authorize(action :: atom, user :: any, params :: any) :: boolean
  end

  def authorize?(action, user, params \\ %{}) do
    if policy = Enum.find(@policies, &(action in &1.actions)) do
      policy.authorize(action, user, params)
    else
      raise "Could not found a policy for action '#{action}'."
    end
  end

  def authorize(action, user, params \\ %{}) do
    case authorize?(action, user, params) do
      true -> :ok
      false -> {:error, :unauthorized}
    end
  end
end
