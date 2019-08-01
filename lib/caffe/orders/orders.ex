defmodule Caffe.Orders do
  @moduledoc """
  The Orders bounded context boundary.
  """

  alias Caffe.{Router, Repo, Menu}
  alias Caffe.Orders.Commands.{OpenTab, PlaceOrder}
  alias Caffe.Orders.Projections.Tab
  alias Caffe.Orders.OrderedItem

  @doc """
  ## Examples

    {:ok, tab_id} = Orders.open_tab %{table_number: 5}
  """
  def open_tab(args) do
    id = UUID.uuid4()
    command = struct(OpenTab, Map.put(args, :tab_id, id))

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
    %PlaceOrder{
      tab_id: tab_id,
      items: Enum.map(items, &fetch_item_details/1)
    }
    |> Router.dispatch(consistency: :strong)
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

    struct(
      OrderedItem,
      Map.merge(item, %{
        is_drink: menu_item.is_drink,
        menu_item_name: menu_item.name,
        price: menu_item.price
      })
    )
  end
end
