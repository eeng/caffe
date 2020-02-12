defmodule Caffe.Menu.UseCases.GetItemTest do
  use Caffe.UseCaseCase, async: true
  alias Caffe.Menu

  describe "execute" do
    test "with existent id" do
      item = insert!(:menu_item)
      {:ok, persisted} = Menu.get_item(item.id)
      assert item.id == persisted.id
    end

    test "with non-existent id" do
      {:error, :not_found} = Menu.get_item(0)
    end
  end
end
