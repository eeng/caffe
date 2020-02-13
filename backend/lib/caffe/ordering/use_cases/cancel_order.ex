defmodule Caffe.Ordering.UseCases.CancelOrder do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  # The order is fetched from DB for authorization
  defstruct [:user, :id, :order]

  @impl true
  def init(%CancelOrder{id: id} = use_case) do
    with {:ok, order} <- Repo.fetch(Order, id) do
      {:ok, %{use_case | order: order}}
    end
  end

  @impl true
  def execute(%CancelOrder{id: id, user: user}) do
    Commands.CancelOrder.new(order_id: id, user_id: user.id)
    |> Router.dispatch(consistency: :strong)
    |> wrap_ok_result
  end

  @impl true
  def authorize(%CancelOrder{user: %User{role: "customer", id: user_id}, order: %Order{} = order}) do
    %{customer_id: cust_id, state: state} = order
    cust_id == user_id && state == "pending"
  end

  def authorize(%CancelOrder{user: %User{}, order: %Order{state: state}}),
    do: state == "pending"
end
