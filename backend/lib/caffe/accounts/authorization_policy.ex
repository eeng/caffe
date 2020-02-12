# TODO vuela
defmodule Caffe.Accounts.AuthorizationPolicy do
  @behaviour Caffe.Authorization.Policy

  alias Caffe.Accounts.User

  def actions do
    [:me, :list_users, :create_user]
  end

  def authorize(:me, %User{}, _), do: true

  def authorize(_, %User{role: "admin"}, _), do: true

  def authorize(_, _, _), do: false
end
