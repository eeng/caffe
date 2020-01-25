defmodule Caffe.Authorization.Authorizer do
  @policies Application.get_env(:caffe, :authorization_policies, [])

  def authorize?(action, user, params \\ nil) do
    if policy = Enum.find(@policies, &(action in &1.actions)) do
      policy.authorize(action, user, params)
    else
      raise "Could not found a policy for action '#{action}'."
    end
  end

  def authorize(action, user, params \\ nil) do
    case authorize?(action, user, params) do
      true -> :ok
      false -> {:error, :unauthorized}
    end
  end

  def authorized_actions(user) do
    all_actions() |> Enum.filter(&authorize?(&1, user))
  end

  def all_actions do
    @policies |> Enum.flat_map(& &1.actions())
  end
end
