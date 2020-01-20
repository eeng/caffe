defmodule Caffe.Ordering.Projections.ActivitiesProjectorTest do
  use Caffe.ProjectorCase, projector: Caffe.Ordering.Projections.ActivitiesProjector, async: true

  alias Caffe.Ordering.Events.{ItemsServed, OrderCancelled}
  alias Caffe.Ordering.Projections.Activity

  test "for each event should create a corresponding activity row" do
    %{id: order_id} = insert!(:order)
    %{id: user_id} = insert!(:admin)

    assert :ok = handle_event(%ItemsServed{user_id: user_id, order_id: order_id})

    assert [
             %Activity{
               type: "ItemsServed",
               actor_id: user_id,
               object_id: order_id,
               object_type: "Order"
             }
           ] = Activity |> Repo.all()

    assert :ok = handle_event(%OrderCancelled{user_id: user_id, order_id: order_id})

    assert [%Activity{type: "ItemsServed"}, %Activity{type: "OrderCancelled"}] =
             Activity |> Repo.all()
  end
end
