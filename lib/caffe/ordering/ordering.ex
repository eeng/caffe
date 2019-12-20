defmodule Caffe.Ordering do
  @moduledoc """
  The Ordering bounded context boundary.
  """

  alias Caffe.{Router, Menu}
  alias Caffe.Ordering.Commands

  def place_order(args) do
    id = UUID.uuid4()

    command =
      args
      |> Map.put(:order_id, id)
      |> update_in([:items, Access.all()], &fetch_item_details/1)
      |> Commands.PlaceOrder.new()

    case Router.dispatch(command, consistency: :strong) do
      :ok -> {:ok, id}
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
end
