defmodule Caffe.Ordering.Queries.KitchenOrdersQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Order
  alias Caffe.Menu

  def new do
    from o in Order,
      where: o.state not in ~w[cancelled paid],
      join: i in assoc(o, :items),
      join: mi in Menu.Item,
      on: mi.id == i.menu_item_id,
      where: i.state in ~w[pending preparing] and mi.is_drink == false,
      order_by: [o.order_date, i.menu_item_name],
      preload: [items: i]
  end
end
