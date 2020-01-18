defmodule Caffe.Ordering.Queries.StatsQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Order

  def new(filters) do
    query =
      from o in Order,
        where: o.state != "cancelled",
        select: %{order_count: count(o.id), amount_earned: sum(o.order_amount) |> coalesce(0)}

    filters
    |> Enum.reduce(query, fn
      {:since, since}, query -> query |> where([o], o.order_date >= ^since)
    end)
  end
end
