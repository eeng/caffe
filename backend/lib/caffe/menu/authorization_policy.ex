defmodule Caffe.Menu.AuthorizationPolicy do
  @behaviour Caffe.Authorization.Policy

  alias Caffe.Accounts.User

  def actions do
    [:create_menu_item, :update_menu_item, :delete_menu_item]
  end

  def authorize(_, %User{role: "admin"}, _), do: true
  def authorize(_, _, _), do: false
end
