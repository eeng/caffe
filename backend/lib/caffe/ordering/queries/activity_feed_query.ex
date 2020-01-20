defmodule Caffe.Ordering.Queries.ActivityFeedQuery do
  import Ecto.Query

  alias Caffe.Ordering.Projections.Activity

  def new do
    from o in Activity, order_by: [desc: o.published], preload: [:actor], limit: 100
  end
end
