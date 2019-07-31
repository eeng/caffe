defmodule Caffe.Menus.MenuItemTest do
  use Caffe.DataCase

  alias Caffe.Menus.MenuItem
  alias Caffe.Repo

  describe "validations" do
    test "name is required" do
      changeset = MenuItem.changeset(%MenuItem{}, %{})
      assert "can't be blank" in errors_on(changeset).name
    end

    test "name is unique" do
      insert!(:menu_item, name: "Chips")

      {:error, changeset} =
        build(:menu_item) |> MenuItem.changeset(%{name: "Chips"}) |> Repo.insert()

      assert "has already been taken" in errors_on(changeset).name
    end

    test "price must be positive" do
      changeset = MenuItem.changeset(%MenuItem{}, %{})
      assert "can't be blank" in errors_on(changeset).price

      changeset = MenuItem.changeset(%MenuItem{}, %{price: -1})
      assert "must be greater than 0" in errors_on(changeset).price
    end
  end
end
