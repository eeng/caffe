defmodule Caffe.Ordering.Queries.ListOrdersQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Order

  def new(user, params) do
    %{order: :desc}
    |> Map.merge(params)
    |> add_customer_filter(user)
    |> Enum.reduce(Order, fn
      {:order, order}, query -> query |> order_by({^order, :order_date})
      {:customer_id, customer_id}, query -> query |> where(customer_id: ^customer_id)
    end)
  end

  defp add_customer_filter(params, %{role: "customer", id: id}),
    do: Map.put(params, :customer_id, id)

  defp add_customer_filter(params, _), do: params
end
