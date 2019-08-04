defmodule Caffe.Orders.Commands.PlaceOrder do
  defstruct [:tab_id, :items]

  use Caffe.Command
  alias Caffe.Orders.Commands.OrderedItem

  validates :tab_id, uuid: true

  validates :items,
    by: &is_list/1,
    length: [min: 1],
    association: [message: "invalid ordered item"]

  def new(args \\ %{}) do
    %{items: items} = command = super(args)
    %{command | items: Enum.map(items, &OrderedItem.new/1)}
  end
end
