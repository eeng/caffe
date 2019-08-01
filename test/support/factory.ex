defmodule Caffe.Factory do
  alias Caffe.{Repo, Menu, Orders}

  # Factories

  def build(:category) do
    %Menu.Category{name: "Sandwich #{random_int()}"}
  end

  def build(:menu_item) do
    %Menu.Item{
      name: "Ham and Egg",
      price: Decimal.new(10),
      category: build(:category)
    }
  end

  def build(:food), do: build(:menu_item, is_drink: false)
  def build(:drink), do: build(:menu_item, is_drink: true)

  def build(:tab) do
    %Orders.Projections.Tab{id: uuid(), table_number: random_int()}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  def uuid do
    UUID.uuid4()
  end

  def random_int do
    System.unique_integer()
  end
end
