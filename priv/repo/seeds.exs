alias Caffe.Menu

defmodule Seeds do
  def create_menu_items(category, items) do
    items
    |> Enum.map(&Map.merge(&1, %{category: category}))
    |> Enum.each(&Menu.create_item(&1))
  end
end

Seeds.create_menu_items("Dishes", [
  %{name: "Bourbon Chicken", price: 20},
  %{name: "Roasted Chicken", price: 10.50},
  %{name: "Greek Salad", price: 12.25},
  %{name: "Hamburger", price: 15},
  %{name: "French Fries", price: 55.50},
  %{name: "Spaghetti Bolognese", price: 32}
])

Seeds.create_menu_items("Drinks", [
  %{name: "Beer", price: 20.50, is_drink: true},
  %{name: "White Wine", price: 21, is_drink: true},
  %{name: "Coca Cola", price: 12.25, is_drink: true},
  %{name: "Water", price: 7.10, is_drink: true}
])
