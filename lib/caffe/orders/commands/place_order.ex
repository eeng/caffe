defmodule Caffe.Orders.Commands.PlaceOrder do
  defstruct [:tab_id, :items]

  use Vex.Struct
  alias Caffe.Orders.Commands.OrderedItem

  validates :tab_id, uuid: true
  validates :items, by: &is_list/1

  def new(args \\ %{}) do
    %{items: items} = command = struct(__MODULE__, args)
    %{command | items: Enum.map(items, &struct(OrderedItem, &1))}
  end
end
