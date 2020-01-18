defmodule Caffe.Ordering do
  @moduledoc """
  The Ordering bounded context boundary.
  """

  alias Caffe.{Router, Repo, Menu}
  alias Caffe.Accounts.User
  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Ordering.Queries.{ListOrdersQuery, StatsQuery}

  @doc """
  ## Examples

    user = Repo.get_by Accounts.User, email: "apocalypse@xmen.com"
    beer = Repo.get_by Menu.Item, name: "Beer"
    hamb = Repo.get_by Menu.Item, name: "Hamburger"
    {:ok, %{id: order_id}} = Ordering.place_order %{items: [%{menu_item_id: beer.id}, %{menu_item_id: hamb.id}], notes: "well done please"}, user
  """
  def place_order(params, user) do
    id = UUID.uuid4()

    command =
      params
      |> Map.put(:order_id, id)
      |> assign_user(user)
      |> update_in([:items, Access.all()], &fetch_item_details/1)
      |> assign_customer_id(user)
      |> Commands.PlaceOrder.new()

    case Router.dispatch(command, consistency: :strong) do
      :ok -> {:ok, get_order(id)}
      reply -> reply
    end
  end

  defp fetch_item_details(%{menu_item_id: id} = item) do
    {:ok, menu_item} = Menu.get_item(id)

    Map.merge(item, %{
      menu_item_name: menu_item.name,
      price: menu_item.price,
      is_drink: menu_item.is_drink
    })
  end

  defp assign_customer_id(command, %User{id: user_id, role: "customer"}) do
    command |> Map.put(:customer_id, user_id)
  end

  defp assign_customer_id(command, _), do: command

  @doc """
  ## Examples

    Ordering.mark_items_served %{order_id: order_id, item_ids: [beer.id, hamb.id]}, user
  """
  def mark_items_served(params, user) do
    params |> assign_user(user) |> Commands.MarkItemsServed.new() |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.begin_food_preparation %{order_id: order_id, item_ids: [hamb.id]}, user
  """
  def begin_food_preparation(params, user) do
    params |> assign_user(user) |> Commands.BeginFoodPreparation.new() |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.mark_food_prepared %{order_id: order_id, item_ids: [hamb.id]}, user
  """
  def mark_food_prepared(params, user) do
    params |> assign_user(user) |> Commands.MarkFoodPrepared.new() |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.pay_order %{order_id: order_id, amount_paid: "3.75"}, user
  """
  def pay_order(params, user) do
    params |> assign_user(user) |> Commands.PayOrder.new() |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.cancel_order %{order_id: order_id}, user
  """
  def cancel_order(params, user) do
    params |> assign_user(user) |> Commands.CancelOrder.new() |> Router.dispatch()
  end

  defp assign_user(params, %User{id: user_id}) do
    Map.put(params, :user_id, user_id)
  end

  def get_order(id) do
    Repo.get(Order, id) |> Repo.preload(:items)
  end

  def list_orders(user, params) do
    ListOrdersQuery.new(user, params) |> Repo.all()
  end

  def get_stats() do
    StatsQuery.new() |> Repo.one()
  end
end
