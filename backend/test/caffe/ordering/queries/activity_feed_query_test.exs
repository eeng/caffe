defmodule Caffe.Ordering.Queries.ActivityFeedQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering

  test "returns the activities sorted by published desc" do
    a3 = insert!(:activity, published: ~U[2016-05-24 13:26:08Z])
    a1 = insert!(:activity, published: ~U[2016-05-24 13:26:06Z])
    a2 = insert!(:activity, published: ~U[2016-05-24 13:26:07Z])

    assert_lists_equal [a3, a2, a1], activity_feed(), by: :published
  end

  def activity_feed do
    with {:ok, activities} <- Ordering.get_activity_feed(build(:admin)) do
      activities
    end
  end
end
