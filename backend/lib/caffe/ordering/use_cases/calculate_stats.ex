defmodule Caffe.Ordering.UseCases.CalculateStats do
  use Caffe.Mediator.UseCase

  alias Caffe.Accounts.User
  alias Caffe.Ordering.Projections.Order

  defstruct [:user, :params]

  @impl true
  def execute(%CalculateStats{params: params}) do
    {:ok, query(params) |> Repo.one()}
  end

  def query(filters) do
    query =
      from o in Order,
        where: o.state != "cancelled",
        select: %{
          order_count: count(o.id),
          amount_earned: sum(o.order_amount) |> coalesce(0),
          tip_earned: sum(o.tip_amount) |> coalesce(0)
        }

    Enum.reduce(filters, query, &filter_by/2)
  end

  defp filter_by({:since, since}, query) do
    query |> where([o], o.order_date >= ^since)
  end

  @impl true
  def authorize(%CalculateStats{user: %User{role: role}}), do: role != "customer"
end
