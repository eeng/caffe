defmodule Caffe.Menu.UseCases.ListItemsTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Menu.UseCases.ListItems

  describe "execute" do
    test "should return all menu items" do
      insert!(:menu_item, name: "Chicken")
      insert!(:menu_item, name: "Beef")

      assert ["Beef", "Chicken"] == list_items() |> Enum.map(& &1.name) |> Enum.sort()
    end

    def list_items do
      {:ok, items} = %ListItems{} |> Mediator.dispatch()
      items
    end
  end

  describe "authorize" do
    test "anyone can list items" do
      assert Authorizer.authorize?(%ListItems{})
    end
  end
end
