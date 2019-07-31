defmodule Caffe.Orders do
  @moduledoc """
  The Orders bounded context boundary.
  """

  alias Caffe.Router
  alias Caffe.Menus
  alias Caffe.Orders.Commands.{OpenTab, PlaceOrder}

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

    beer = Repo.get_by Menus.MenuItem, name: "Beer"
    hamb = Repo.get_by Menus.MenuItem, name: "Hamburger"
    Orders.place_order %{tab_id: tab_id, items: [%{menu_item_id: beer.id}, %{menu_item_id: hamb.id}]}
  """
  def place_order(%{tab_id: tab_id, items: items}) do
    %PlaceOrder{
      tab_id: tab_id,
      items: Enum.map(items, &fetch_item_details/1)
    }
    |> Router.dispatch(consistency: :strong)
  end

  defp fetch_item_details(%{menu_item_id: id} = item) do
    stored_details = Menus.get_menu_item(id) |> Map.take([:is_drink, :price])
    Map.merge(item, stored_details)
  end
end
