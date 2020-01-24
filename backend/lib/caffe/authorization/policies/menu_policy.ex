defmodule Caffe.Authorization.Policies.MenuPolicy do
  @behaviour Caffe.Authorization.Authorizer.Policy

  alias Caffe.Accounts.User

  def actions do
    [:create_menu_item, :update_menu_item, :delete_menu_item]
  end

  def authorize(_, %User{role: "admin"}, _), do: true
  def authorize(_, _, _), do: false
end
