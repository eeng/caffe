defmodule Caffe.Authorization.Policies.OrderingPolicy do
  @behaviour Caffe.Authorization.Authorizer.Policy
  @dialyzer :no_undefined_callbacks

  alias Caffe.Accounts.User
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Repo

  def actions do
    [
      :place_order,
      :cancel_order,
      :mark_items_served,
      :begin_food_preparation,
      :mark_food_prepared,
      :pay_order,
      :get_order,
      :list_orders,
      :list_kitchen_orders,
      :get_stats,
      :get_activity_feed
    ]
  end

  def authorize(:place_order, %User{}, _), do: true

  def authorize(:mark_items_served, %User{role: "waitstaff"}, _), do: true
  def authorize(:begin_food_preparation, %User{role: "chef"}, _), do: true
  def authorize(:mark_food_prepared, %User{role: "chef"}, _), do: true
  def authorize(:pay_order, %User{}, _), do: true

  def authorize(:cancel_order, %User{role: "customer", id: user_id}, %Order{
        customer_id: cust_id,
        state: state
      }),
      do: cust_id == user_id && state == "pending"

  def authorize(:cancel_order, %User{}, %Order{state: state}),
    do: state == "pending"

  def authorize(:cancel_order, _, %Order{}), do: false

  def authorize(:cancel_order, user, %{order_id: order_id}) do
    authorize(:cancel_order, user, Repo.get(Order, order_id))
  end

  def authorize(:get_order, %User{role: "customer", id: user_id}, %Order{customer_id: cust_id}),
    do: user_id == cust_id

  def authorize(:get_order, _, %Order{}), do: true
  def authorize(:get_order, _, nil), do: true

  def authorize(:get_order, user, %{id: id}) do
    authorize(:get_order, user, Repo.get(Order, id))
  end

  def authorize(:list_orders, %User{}, _), do: true

  def authorize(employee_action, %User{role: role}, _)
      when employee_action in [:list_kitchen_orders, :get_stats, :get_activity_feed] do
    role != "customer"
  end

  def authorize(_, _, _), do: false
end
