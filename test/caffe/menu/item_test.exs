defmodule Caffe.Menu.ItemTest do
  use Caffe.DataCase, async: true

  alias Caffe.Menu.Item
  alias Caffe.Repo

  describe "validations" do
    test "name is required" do
      changeset = Item.changeset(%Item{}, %{})
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name is unique" do
      insert!(:menu_item, name: "Chips")
      {:error, changeset} = build(:menu_item) |> Item.changeset(%{name: "Chips"}) |> Repo.insert()
      assert "has already been taken" in errors_on(changeset).name
    end

    test "price must be positive" do
      changeset = Item.changeset(%Item{}, %{})
      assert "can't be blank" in errors_on(changeset).price

      changeset = Item.changeset(%Item{}, %{price: -1})
      assert "must be greater than or equal to 0" in errors_on(changeset).price
    end
  end
end
