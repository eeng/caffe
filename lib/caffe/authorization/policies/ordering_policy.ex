defmodule Caffe.Authorization.Policies.OrderingPolicy do
  @behaviour Caffe.Authorization.Authorizer.Policy
  @dialyzer :no_undefined_callbacks

  alias Caffe.Accounts.User
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Repo

  def actions do
    [:place_order, :cancel_order]
  end

  def authorize(:place_order, %User{}, _), do: true

  def authorize(:cancel_order, user, %{order_id: order_id}) do
    authorize(:cancel_order, user, Repo.get(Order, order_id))
  end

  def authorize(:cancel_order, %User{role: "customer", id: user_id}, %Order{customer_id: user_id}),
    do: true

  def authorize(:cancel_order, %User{role: role}, %Order{}) when role != "customer", do: true

  def authorize(_, _, _), do: false
end
