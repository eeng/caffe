defmodule Caffe.Orders.Projections.TabsProjectorTest do
  use Caffe.ProjectorCase, projector: Caffe.Orders.Projections.TabsProjector

  alias Caffe.Orders.Events.{ItemsServed, DrinksOrdered}
  alias Caffe.Orders.Projections.TabItem

  describe "DrinksOrdered event" do
    test "should insert the items for the tab" do
      %{id: tab1} = insert!(:tab)
      %{id: tab2} = insert!(:tab)

      assert :ok = handle_event(%DrinksOrdered{tab_id: tab1, items: [params_for(:tab_item)]})

      assert ["pending"] == item_statuses_of_tab(tab1)
      assert [] == item_statuses_of_tab(tab2)
    end
  end

  describe "ItemsServed event" do
    test "should change served tab item status" do
      %{id: tab1} = insert!(:tab, items: [%{menu_item_id: 1}, %{menu_item_id: 2}])
      %{id: tab2} = insert!(:tab, items: [%{menu_item_id: 1}, %{menu_item_id: 2}])

      assert :ok = handle_event(%ItemsServed{tab_id: tab1, item_ids: [2]})

      assert ["pending", "served"] == item_statuses_of_tab(tab1)
      assert ["pending", "pending"] == item_statuses_of_tab(tab2)
    end
  end

  def item_statuses_of_tab(tab_id) do
    from(i in TabItem, select: i.status, where: i.tab_id == ^tab_id) |> Repo.all()
  end
end
