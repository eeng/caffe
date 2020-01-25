defmodule Caffe.Accounts.AuthorizationPolicy do
  @behaviour Caffe.Authorization.Policy

  alias Caffe.Accounts.User

  def actions do
    [:me, :list_users]
  end

  def authorize(:me, %User{}, _), do: true

  def authorize(:list_users, %User{role: "admin"}, _), do: true

  def authorize(_, _, _), do: false
end
