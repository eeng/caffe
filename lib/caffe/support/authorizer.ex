defmodule Caffe.Support.Authorizer do
  defmodule Policy do
    @callback authorize(action :: atom, user :: any, params :: any) :: boolean
  end

  def authorize(policy, action, user, params \\ %{}) do
    case authorize?(policy, action, user, params) do
      true -> :ok
      false -> {:error, :unauthorized}
    end
  end

  def authorize?(policy, action, user, params \\ %{}) do
    policy.authorize(action, user, params)
  end
end
