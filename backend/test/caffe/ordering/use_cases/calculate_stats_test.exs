defmodule Caffe.Ordering.UseCases.CalculateStatsTest do
  use Caffe.UseCaseCase

  import Caffe.Sigils

  alias Caffe.Ordering.UseCases.CalculateStats
  alias Caffe.Accounts.User

  describe "execute" do
    test "calculates the order count, amount and tip earned" do
      assert %{order_count: 0, amount_earned: ~d(0), tip_earned: ~d(0)} == calculate_stats()

      insert!(:order, order_amount: 10, tip_amount: 3)
      insert!(:order, order_amount: 5.25, tip_amount: 1)
      assert %{order_count: 2, amount_earned: ~d(15.25), tip_earned: ~d(4)} == calculate_stats()
    end

    test "can be filtered by order date" do
      insert!(:order, order_amount: 10, order_date: ~U[2020-01-01 00:00:00Z])
      insert!(:order, order_amount: 20, order_date: ~U[2020-01-02 00:00:00Z])

      assert %{amount_earned: ~d(30)} = calculate_stats(%{since: ~U[2020-01-01 00:00:00Z]})
      assert %{amount_earned: ~d(20)} = calculate_stats(%{since: ~U[2020-01-01 00:00:01Z]})
    end

    test "cancelled orders don't count" do
      insert!(:order, order_amount: 5, state: "cancelled")
      assert %{order_count: 0} = calculate_stats()
    end

    defp calculate_stats(params \\ %{}) do
      with {:ok, stats} <- Caffe.Ordering.calculate_stats(params, build(:admin)) do
        stats
      end
    end
  end

  describe "authorize" do
    test "customers can't view the stats" do
      assert Authorizer.authorize?(%CalculateStats{user: %User{role: "admin"}})
      refute Authorizer.authorize?(%CalculateStats{user: %User{role: "customer"}})
      refute Authorizer.authorize?(%CalculateStats{user: nil})
    end
  end
end
