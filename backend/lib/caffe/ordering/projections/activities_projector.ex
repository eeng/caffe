defmodule Caffe.Ordering.Projections.ActivitiesProjector do
  use Commanded.Projections.Ecto,
    application: Caffe.Commanded.Application,
    name: "Ordering.Projections.ActivitiesProjector",
    consistency: :eventual,
    start_from: :origin

  alias Ecto.Multi
  alias Caffe.Ordering.Projections.{Activity, Order}

  project %{user_id: user_id, order_id: order_id} = evt, %{created_at: created_at}, fn multi ->
    activity = %Activity{
      type: struct_name(evt),
      actor_id: user_id,
      published: DateTime.truncate(created_at, :second),
      object_id: order_id,
      object_type: struct_name(%Order{})
    }

    Multi.insert(multi, :insert, activity)
  end

  defp struct_name(evt) do
    evt.__struct__ |> to_string |> to_string |> String.split(".") |> List.last()
  end
end
