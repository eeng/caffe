defmodule Caffe.Ordering do
  import Caffe.Authorization.Macros, only: [authorize: 2]
  alias Caffe.Authorization.Authorizer
  alias Caffe.{Router, Repo, Menu}
  alias Caffe.Accounts.User
  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Projections.Order

  alias Caffe.Ordering.Queries.{
    ListOrdersQuery,
    StatsQuery,
    ActivityFeedQuery,
    KitchenOrdersQuery,
    WaitstaffOrdersQuery
  }

  @doc """
  ## Examples

    user = Repo.get_by Accounts.User, email: "apocalypse@xmen.com"
    beer = Repo.get_by Menu.Item, name: "Beer"
    hamb = Repo.get_by Menu.Item, name: "Hamburger"
    {:ok, %{id: order_id}} = Ordering.place_order %{items: [%{menu_item_id: beer.id}, %{menu_item_id: hamb.id}], notes: "well done please"}, user
  """
  def place_order(params, user) do
    authorize user do
      id = UUID.uuid4()

      command =
        params
        |> Map.put(:order_id, id)
        |> assign_user(user)
        |> update_in([:items, Access.all()], &fetch_item_details/1)
        |> assign_customer_id(user)
        |> Commands.PlaceOrder.new()

      case Router.dispatch(command, consistency: :strong) do
        :ok -> get_order(id, user)
        reply -> reply
      end
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
    authorize user do
      params
      |> assign_user(user)
      |> Commands.MarkItemsServed.new()
      |> Router.dispatch(consistency: :strong)
    end
  end

  @doc """
  ## Examples

    Ordering.begin_food_preparation %{order_id: order_id, item_ids: [hamb.id]}, user
  """
  def begin_food_preparation(params, user) do
    authorize user do
      params
      |> assign_user(user)
      |> Commands.BeginFoodPreparation.new()
      |> Router.dispatch(consistency: :strong)
    end
  end

  @doc """
  ## Examples

    Ordering.mark_food_prepared %{order_id: order_id, item_ids: [hamb.id]}, user
  """
  def mark_food_prepared(params, user) do
    authorize user do
      params
      |> assign_user(user)
      |> Commands.MarkFoodPrepared.new()
      |> Router.dispatch(consistency: :strong)
    end
  end

  @doc """
  ## Examples

    Ordering.pay_order %{order_id: order_id, amount_paid: "3.75"}, user
  """
  def pay_order(params, user) do
    authorize user do
      params
      |> assign_user(user)
      |> Commands.PayOrder.new()
      |> Router.dispatch(consistency: :strong)
    end
  end

  @doc """
  ## Examples

    Ordering.cancel_order %{order_id: order_id}, user
  """
  def cancel_order(%{order_id: id} = params, user) do
    with {:ok, order} <- Repo.fetch(Order, id),
         :ok <- Authorizer.authorize(:cancel_order, user, order) do
      params
      |> assign_user(user)
      |> Commands.CancelOrder.new()
      |> Router.dispatch(consistency: :strong)
    end
  end

  defp assign_user(params, %User{id: user_id}) do
    Map.put(params, :user_id, user_id)
  end

  def get_order(id, user) do
    with {:ok, order} <- Repo.fetch(Order, id),
         :ok <- Authorizer.authorize(:get_order, user, order) do
      {:ok, order |> Repo.preload(:items)}
    else
      error -> error
    end
  end

  def list_orders(user, params) do
    authorize user do
      {:ok, ListOrdersQuery.new(user, params) |> Repo.all()}
    end
  end

  def list_kitchen_orders(user) do
    authorize user do
      {:ok, KitchenOrdersQuery.new() |> Repo.all()}
    end
  end

  def list_waitstaff_orders(user) do
    authorize user do
      {:ok, WaitstaffOrdersQuery.new() |> Repo.all()}
    end
  end

  def get_stats(params, user) do
    authorize user do
      {:ok, StatsQuery.new(params) |> Repo.one()}
    end
  end

  def get_activity_feed(user) do
    authorize user do
      {:ok, ActivityFeedQuery.new() |> Repo.all()}
    end
  end
end
