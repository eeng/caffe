defmodule Caffe.Ordering.Queries.StatsQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering
  import Caffe.Sigils

  test "calculates the order count and amount earned" do
    assert %{order_count: 0, amount_earned: ~d(0)} == Ordering.get_stats()

    insert!(:order, order_amount: 10)
    insert!(:order, order_amount: 5.25)
    assert %{order_count: 2, amount_earned: ~d(15.25)} == Ordering.get_stats()
  end
end
