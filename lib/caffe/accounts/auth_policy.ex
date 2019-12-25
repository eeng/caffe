defmodule Caffe.Accounts.AuthPolicy do
  @behaviour Caffe.Support.Authorizer.Policy
  @dialyzer :no_undefined_callbacks

  alias Caffe.Accounts.User

  def authorize(:list_users, %User{role: "admin"}, _), do: true

  def authorize(_, _, _), do: false
end
