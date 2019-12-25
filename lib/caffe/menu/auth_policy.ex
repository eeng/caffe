defmodule Caffe.Menu.AuthPolicy do
  @behaviour Caffe.Support.Authorizer.Policy
  @dialyzer :no_undefined_callbacks

  alias Caffe.Accounts.User

  def authorize(action, %User{role: "admin"}, _)
      when action in [:create_menu_item, :update_menu_item, :delete_menu_item],
      do: true

  def authorize(_, _, _), do: false
end
