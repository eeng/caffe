defmodule Caffe.Ordering.AuthPolicy do
  @behaviour Caffe.Support.Authorizer.Policy
  @dialyzer :no_undefined_callbacks

  alias Caffe.Accounts.User
  alias Caffe.Ordering.Projections.Order

  def authorize(:place_order, %User{}, _), do: true

  def authorize(:cancel_order, %User{role: "customer", id: user_id}, %Order{customer_id: user_id}),
    do: true

  def authorize(:cancel_order, %User{role: role}, %Order{}) when role != "customer", do: true

  def authorize(_, _, _), do: false
end
