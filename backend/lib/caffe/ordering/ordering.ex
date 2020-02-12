defmodule Caffe.Ordering do
  alias Caffe.Mediator

  alias Caffe.Ordering.UseCases.{
    PlaceOrder,
    CancelOrder,
    MarkItemsServed,
    BeginFoodPreparation,
    MarkFoodPrepared,
    PayOrder,
    GetOrder,
    ListOrders,
    GetKitchenOrders,
    GetWaitstaffOrders,
    GetActivityFeed,
    CalculateStats
  }

  @doc """
  ## Examples

    user = Repo.get_by Accounts.User, email: "apocalypse@xmen.com"
    beer = Repo.get_by Menu.Item, name: "Beer"
    hamb = Repo.get_by Menu.Item, name: "Hamburger"
    {:ok, %{id: order_id}} = Ordering.place_order %{items: [%{menu_item_id: beer.id}, %{menu_item_id: hamb.id}], notes: "well done please"}, user
  """
  def place_order(params, user) do
    %PlaceOrder{user: user, params: params} |> Mediator.dispatch()
  end

  @doc """
  ## Examples

    Ordering.mark_items_served %{order_id: order_id, item_ids: [beer.id, hamb.id]}, user
  """
  def mark_items_served(params, user) do
    %MarkItemsServed{user: user, params: params} |> Mediator.dispatch()
  end

  @doc """
  ## Examples

    Ordering.begin_food_preparation %{order_id: order_id, item_ids: [hamb.id]}, user
  """
  def begin_food_preparation(params, user) do
    %BeginFoodPreparation{user: user, params: params} |> Mediator.dispatch()
  end

  @doc """
  ## Examples

    Ordering.mark_food_prepared %{order_id: order_id, item_ids: [hamb.id]}, user
  """
  def mark_food_prepared(params, user) do
    %MarkFoodPrepared{user: user, params: params} |> Mediator.dispatch()
  end

  @doc """
  ## Examples

    Ordering.pay_order %{order_id: order_id, amount_paid: "3.75"}, user
  """
  def pay_order(params, user) do
    %PayOrder{user: user, params: params} |> Mediator.dispatch()
  end

  @doc """
  ## Examples

    Ordering.cancel_order %{order_id: order_id}, user
  """
  def cancel_order(id, user) do
    %CancelOrder{user: user, id: id} |> Mediator.dispatch()
  end

  def get_order(id, user) do
    %GetOrder{user: user, id: id} |> Mediator.dispatch()
  end

  def list_orders(user, params) do
    %ListOrders{user: user, params: params} |> Mediator.dispatch()
  end

  def list_kitchen_orders(user) do
    %GetKitchenOrders{user: user} |> Mediator.dispatch()
  end

  def list_waitstaff_orders(user) do
    %GetWaitstaffOrders{user: user} |> Mediator.dispatch()
  end

  def calculate_stats(params, user) do
    %CalculateStats{user: user, params: params} |> Mediator.dispatch()
  end

  def get_activity_feed(user) do
    %GetActivityFeed{user: user} |> Mediator.dispatch()
  end
end
