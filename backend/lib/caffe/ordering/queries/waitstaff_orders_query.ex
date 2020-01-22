defmodule Caffe.Ordering.Queries.WaitstaffOrdersQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Order

  def new do
    from o in Order,
      where: o.state in ~w[pending served],
      join: i in assoc(o, :items),
      order_by: [o.state, o.order_date, not i.is_drink, i.menu_item_name],
      preload: [items: i]
  end
end
