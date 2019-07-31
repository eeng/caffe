alias Caffe.Menus

defmodule DatabaseSeeder do
  def create_menu_items(category, items) do
    items
    |> Enum.map(&Map.merge(&1, %{category: category}))
    |> Enum.each(&Menus.create_menu_item(&1))
  end
end

DatabaseSeeder.create_menu_items("Dishes", [
  %{name: "Bourbon Chicken", price: 2000},
  %{name: "Roasted Chicken", price: 1000},
  %{name: "Greek Salad", price: 1200},
  %{name: "Hamburger", price: 800},
  %{name: "French Fries", price: 5500},
  %{name: "Spaghetti Bolognese", price: 3200}
])

DatabaseSeeder.create_menu_items("Drinks", [
  %{name: "Beer", price: 2000},
  %{name: "White Wine", price: 2000},
  %{name: "Coca Cola", price: 1200},
  %{name: "Water", price: 700}
])
