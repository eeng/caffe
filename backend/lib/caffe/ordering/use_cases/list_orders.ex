defmodule Caffe.Ordering.UseCases.ListOrders do
  use Caffe.Mediator.UseCase

  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  defstruct [:user, :params]

  @impl true
  def authorize(%ListOrders{user: %User{}}), do: true

  @impl true
  def execute(%ListOrders{user: user, params: params}) do
    {:ok, query(user, params) |> Repo.all()}
  end

  def query(user, params) do
    %{order: :desc}
    |> Map.merge(params)
    |> add_customer_filter(user)
    |> Enum.reduce(Order, fn
      {:order, order}, query -> query |> order_by({^order, :order_date})
      {:customer_id, customer_id}, query -> query |> where(customer_id: ^customer_id)
    end)
    |> limit(100)
  end

  defp add_customer_filter(params, %{role: "customer", id: id}),
    do: Map.put(params, :customer_id, id)

  defp add_customer_filter(params, _), do: params
end
