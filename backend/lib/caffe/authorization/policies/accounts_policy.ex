defmodule Caffe.Authorization.Policies.AccountsPolicy do
  @behaviour Caffe.Authorization.Authorizer.Policy
  @dialyzer :no_undefined_callbacks

  alias Caffe.Accounts.User

  def actions do
    [:list_users]
  end

  def authorize(_, %User{role: "admin"}, _), do: true
  def authorize(_, _, _), do: false
end
