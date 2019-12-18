defmodule Caffe.Factory do
  alias Caffe.{Repo, Menu, Orders, Accounts}

  # Factories

  def build(:category) do
    %Menu.Category{name: "Sandwich #{sequence()}"}
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
    %Orders.Projections.Tab{id: uuid(), table_number: sequence()}
  end

  def build(:tab_item) do
    %Orders.Projections.TabItem{menu_item_id: 1, menu_item_name: "Food", price: 10, quantity: 1}
  end

  def build(:user) do
    %Accounts.User{email: "max@acme.com", password: "secret", role: "admin", name: "Max"}
  end

  # Convenience API

  def build(factory_name, attributes) do
    factory_name |> build() |> struct(attributes)
  end

  def insert!(factory_name, attributes \\ []) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  def params_for(factory_name, attributes \\ []) do
    build(factory_name, attributes) |> Map.from_struct()
  end

  def uuid do
    UUID.uuid4()
  end

  def sequence do
    :erlang.unique_integer([:positive, :monotonic])
  end
end
