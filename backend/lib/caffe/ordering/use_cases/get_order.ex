defmodule Caffe.Ordering.UseCases.GetOrder do
  use Caffe.Mediator.UseCase
  alias Caffe.Ordering.Projections.Order
  alias Caffe.Accounts.User

  defstruct [:user, :id, :order]

  @impl true
  def init(%GetOrder{id: id} = use_case) do
    with {:ok, order} <- Repo.fetch(Order, id) do
      {:ok, %{use_case | order: order}}
    end
  end

  @impl true
  def authorize(%GetOrder{
        user: %User{role: "customer", id: user_id},
        order: %Order{customer_id: cust_id}
      }),
      do: user_id == cust_id

  def authorize(%GetOrder{user: %User{}}), do: true

  @impl true
  def execute(%GetOrder{order: order}) do
    {:ok, order |> Repo.preload(:items)}
  end
end
