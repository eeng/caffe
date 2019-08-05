defmodule Caffe.Orders do
  @moduledoc """
  The Orders bounded context boundary.
  """

  alias Caffe.{Router, Repo, Menu}

  alias Caffe.Orders.Commands.{
    OpenTab,
    PlaceOrder,
    BeginFoodPreparation,
    MarkFoodPrepared,
    MarkItemsServed,
    CloseTab
  }

  alias Caffe.Orders.Projections.Tab

  @doc """
  ## Examples

    {:ok, tab_id} = Orders.open_tab %{table_number: 8}
  """
  def open_tab(args) do
    id = UUID.uuid4()
    command = args |> Map.put(:tab_id, id) |> OpenTab.new()

    case Router.dispatch(command, consistency: :strong) do
      :ok -> {:ok, id}
      reply -> reply
    end
  end

  @doc """
  ## Examples

    beer = Repo.get_by Menu.Item, name: "Beer"
    hamb = Repo.get_by Menu.Item, name: "Hamburger"
    Orders.place_order %{tab_id: tab_id, items: [%{menu_item_id: beer.id}, %{menu_item_id: hamb.id, notes: "well done please"}]}
  """
  def place_order(%{tab_id: tab_id, items: items}) do
    PlaceOrder.new(
      tab_id: tab_id,
      items: Enum.map(items, &fetch_item_details/1)
    )
    |> Router.dispatch(consistency: :strong)
  end

  @doc """
  ## Examples

    Orders.mark_items_served %{tab_id: tab_id, item_ids: [beer.id, hamb.id]}
  """
  def mark_items_served(args) do
    MarkItemsServed.new(args) |> Router.dispatch()
  end

  @doc """
  ## Examples

    Orders.begin_food_preparation %{tab_id: tab_id, item_ids: [hamb.id]}
  """
  def begin_food_preparation(args) do
    BeginFoodPreparation.new(args) |> Router.dispatch()
  end

  @doc """
  ## Examples

    Orders.mark_food_prepared %{tab_id: tab_id, item_ids: [hamb.id]}
  """
  def mark_food_prepared(args) do
    MarkFoodPrepared.new(args) |> Router.dispatch()
  end

  @doc """
  ## Examples

    Orders.close_tab %{tab_id: tab_id, amount_paid: "3.75"}
  """
  def close_tab(args) do
    CloseTab.new(args) |> Router.dispatch(consistency: :strong)
  end

  @doc """
  ## Examples

    Orders.get_tab tab_id
  """
  def get_tab(tab_id) do
    Tab |> Repo.get(tab_id) |> Repo.preload(:items)
  end

  defp fetch_item_details(%{menu_item_id: id} = item) do
    menu_item = Menu.get_item(id)

    Map.merge(item, %{
      menu_item_name: menu_item.name,
      price: menu_item.price,
      is_drink: menu_item.is_drink
    })
  end
end
