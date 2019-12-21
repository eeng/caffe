defmodule Caffe.Ordering do
  @moduledoc """
  The Ordering bounded context boundary.
  """

  alias Caffe.{Router, Repo, Menu, Accounts}
  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Projections.Order

  @doc """
  ## Examples

    user = Repo.get_by Accounts.User, email: "apocalypse@xmen.com"
    beer = Repo.get_by Menu.Item, name: "Beer"
    hamb = Repo.get_by Menu.Item, name: "Hamburger"
    Ordering.place_order %{user_id: user.id, items: [%{menu_item_id: beer.id}, %{menu_item_id: hamb.id}], notes: "well done please"}
  """
  def place_order(args) do
    id = UUID.uuid4()

    command =
      args
      |> Map.put(:order_id, id)
      |> update_in([:items, Access.all()], &fetch_item_details/1)
      |> assign_customer_id(args)
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

  defp assign_customer_id(command, %{user_id: user_id}) do
    with {:ok, %{id: id, role: "customer"}} <- Accounts.get_user(user_id) do
      command |> Map.put(:customer_id, id)
    else
      _ -> command
    end
  end

  @doc """
  ## Examples

    Ordering.mark_items_served %{order_id: order_id, item_ids: [beer.id, hamb.id]}
  """
  def mark_items_served(args) do
    Commands.MarkItemsServed.new(args) |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.begin_food_preparation %{order_id: order_id, item_ids: [hamb.id]}
  """
  def begin_food_preparation(args) do
    Commands.BeginFoodPreparation.new(args) |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.mark_food_prepared %{order_id: order_id, item_ids: [hamb.id]}
  """
  def mark_food_prepared(args) do
    Commands.MarkFoodPrepared.new(args) |> Router.dispatch()
  end

  @doc """
  ## Examples

    Ordering.pay_order %{order_id: order_id, amount_paid: "3.75"}
  """
  def pay_order(args) do
    Commands.PayOrder.new(args) |> Router.dispatch(consistency: :strong)
  end

  def get_order(id) do
    Repo.get(Order, id) |> Repo.preload(:items)
  end
end
