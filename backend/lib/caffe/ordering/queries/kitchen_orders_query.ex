defmodule Caffe.Ordering.Queries.KitchenOrdersQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Order

  def new do
    from o in Order,
      where: o.state in ~w[pending],
      join: i in assoc(o, :items),
      where: i.state in ~w[pending preparing] and i.is_drink == false,
      order_by: [o.order_date, i.menu_item_name],
      preload: [items: i]
  end
end
