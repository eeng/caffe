alias Caffe.{Repo, Menu}

sandwiches = %Menu.Category{name: "Sandwiches", position: 1} |> Repo.insert!()
%Menu.Item{name: "Reuben", price: 4.50, category: sandwiches} |> Repo.insert!()
%Menu.Item{name: "Croque Monsieur", price: 6.25, category: sandwiches} |> Repo.insert!()
%Menu.Item{name: "Muffuletta", price: 5.50, category: sandwiches} |> Repo.insert!()
%Menu.Item{name: "Bánh mì", price: 7, category: sandwiches} |> Repo.insert!()
%Menu.Item{name: "Vada Pav", price: 4.50, category: sandwiches} |> Repo.insert!()
%Menu.Item{name: "Hamburger", price: 1.50, category: sandwiches} |> Repo.insert!()

sides = %Menu.Category{name: "Sides", position: 2} |> Repo.insert!()
%Menu.Item{name: "French Fries", price: 2.50, category: sides} |> Repo.insert!()
%Menu.Item{name: "Papadum", price: 1.25, category: sides} |> Repo.insert!()
%Menu.Item{name: "Pasta Salad", price: 2.50, category: sides} |> Repo.insert!()
%Menu.Item{name: "Thai Salad", price: 3.50, category: sides} |> Repo.insert!()

beverages = %Menu.Category{name: "Beverages", position: 3} |> Repo.insert!()
%Menu.Item{name: "Water", price: 0, is_drink: true, category: beverages} |> Repo.insert!()
%Menu.Item{name: "Beer", price: 1.5, is_drink: true, category: beverages} |> Repo.insert!()
%Menu.Item{name: "Lemonade", price: 1.25, is_drink: true, category: beverages} |> Repo.insert!()
%Menu.Item{name: "Masala Chai", price: 1.5, is_drink: true, category: beverages} |> Repo.insert!()
%Menu.Item{name: "Milkshake", price: 3, is_drink: true, category: beverages} |> Repo.insert!()
