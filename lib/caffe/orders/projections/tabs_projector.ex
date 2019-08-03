defmodule Caffe.Orders.Projections.TabsProjector do
  use Commanded.Projections.Ecto, name: "Orders.Projection.TabsProjector", consistency: :strong

  alias Ecto.Multi

  alias Caffe.Orders.Events.{TabOpened, DrinksOrdered, FoodOrdered, DrinksServed}
  alias Caffe.Orders.Projections.{Tab, TabItem}

  project %TabOpened{tab_id: id, table_number: table_number}, fn multi ->
    Multi.insert(multi, :tab, %Tab{id: id, table_number: table_number})
  end

  project %DrinksOrdered{tab_id: tab_id, items: items}, fn multi ->
    insert_tab_items(multi, items, tab_id)
  end

  project %FoodOrdered{tab_id: tab_id, items: items}, fn multi ->
    insert_tab_items(multi, items, tab_id)
  end

  project %DrinksServed{tab_id: tab_id, item_ids: item_ids}, fn multi ->
    query = from i in TabItem, where: i.tab_id == ^tab_id and i.menu_item_id in ^item_ids
    Multi.update_all(multi, :update_status, query, set: [status: "served"])
  end

  defp insert_tab_items(multi, items, tab_id) do
    Enum.reduce(items, multi, fn item, multi ->
      tab_item =
        %TabItem{}
        |> TabItem.changeset(item)
        |> put_change(:tab_id, tab_id)

      Multi.insert(multi, "item_#{item.menu_item_id}", tab_item)
    end)
  end
end
