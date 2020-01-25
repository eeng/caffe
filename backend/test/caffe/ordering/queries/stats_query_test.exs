defmodule Caffe.Ordering.Queries.StatsQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering
  import Caffe.Sigils

  test "calculates the order count and amount earned" do
    assert %{order_count: 0, amount_earned: ~d(0)} == get_stats()

    insert!(:order, order_amount: 10)
    insert!(:order, order_amount: 5.25)
    assert %{order_count: 2, amount_earned: ~d(15.25)} == get_stats()
  end

  test "can be filtered by order date" do
    insert!(:order, order_amount: 10, order_date: ~U[2020-01-01 00:00:00Z])
    insert!(:order, order_amount: 20, order_date: ~U[2020-01-02 00:00:00Z])

    assert %{amount_earned: ~d(30)} = get_stats(%{since: ~U[2020-01-01 00:00:00Z]})
    assert %{amount_earned: ~d(20)} = get_stats(%{since: ~U[2020-01-01 00:00:01Z]})
  end

  test "cancelled orders don't count" do
    insert!(:order, order_amount: 5, state: "cancelled")
    assert %{order_count: 0} = get_stats()
  end

  defp get_stats(params \\ %{}) do
    Ordering.get_stats(params, build(:admin))
  end
end
