defmodule Caffe.Seeds do
  alias Caffe.{Repo, Menu}

  def run do
    sandwiches = %Menu.Category{name: "Sandwiches", position: 1} |> upsert_by(:name)
    %Menu.Item{name: "Reuben", price: 4.50, category: sandwiches} |> upsert_by(:name)
    %Menu.Item{name: "Croque Monsieur", price: 6.25, category: sandwiches} |> upsert_by(:name)
    %Menu.Item{name: "Muffuletta", price: 5.50, category: sandwiches} |> upsert_by(:name)
    %Menu.Item{name: "Bánh mì", price: 7, category: sandwiches} |> upsert_by(:name)
    %Menu.Item{name: "Vada Pav", price: 4.50, category: sandwiches} |> upsert_by(:name)
    %Menu.Item{name: "Hamburger", price: 2, category: sandwiches} |> upsert_by(:name)

    sides = %Menu.Category{name: "Sides", position: 2} |> upsert_by(:name)
    %Menu.Item{name: "French Fries", price: 2.50, category: sides} |> upsert_by(:name)
    %Menu.Item{name: "Papadum", price: 1.25, category: sides} |> upsert_by(:name)
    %Menu.Item{name: "Pasta Salad", price: 2.50, category: sides} |> upsert_by(:name)
    %Menu.Item{name: "Thai Salad", price: 3.50, category: sides} |> upsert_by(:name)

    beverages = %Menu.Category{name: "Beverages", position: 3} |> upsert_by(:name)
    %Menu.Item{name: "Water", price: 0, is_drink: true, category: beverages} |> upsert_by(:name)
    %Menu.Item{name: "Beer", price: 1.5, is_drink: true, category: beverages} |> upsert_by(:name)

    %Menu.Item{name: "Lemonade", price: 1.25, is_drink: true, category: beverages}
    |> upsert_by(:name)

    %Menu.Item{name: "Masala Chai", price: 1.5, is_drink: true, category: beverages}
    |> upsert_by(:name)

    %Menu.Item{name: "Milkshake", price: 3, is_drink: true, category: beverages}
    |> upsert_by(:name)
  end

  defp upsert_by(record, conflict_target) do
    Repo.insert!(record,
      on_conflict: :replace_all_except_primary_key,
      conflict_target: conflict_target
    )
  end
end
