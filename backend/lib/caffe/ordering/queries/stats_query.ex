defmodule Caffe.Ordering.Queries.StatsQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Order

  def new() do
    from o in Order,
      select: %{order_count: count(o.id), amount_earned: sum(o.order_amount) |> coalesce(0)}
  end
end
