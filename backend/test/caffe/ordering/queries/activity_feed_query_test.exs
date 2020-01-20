defmodule Caffe.Ordering.Queries.ActivityFeedQueryTest do
  use Caffe.DataCase, async: true

  alias Caffe.Ordering

  test "returns the activities sorted by published desc" do
    %{published: d3} = insert!(:activity, published: ~U[2016-05-24 13:26:08Z])
    %{published: d1} = insert!(:activity, published: ~U[2016-05-24 13:26:06Z])
    %{published: d2} = insert!(:activity, published: ~U[2016-05-24 13:26:07Z])

    assert [d3, d2, d1] == Ordering.get_activity_feed() |> Enum.map(& &1.published)
  end
end
