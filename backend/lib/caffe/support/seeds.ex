defmodule Caffe.Seeds do
  alias Caffe.{Repo, Menu}
  alias Caffe.Accounts.{User, Password}

  def run do
    create_users()
    create_menu()
  end

  defp create_users do
    upsert_all_by(:email, [
      %User{
        email: "admin@caffe.com",
        password: Password.hash("secret"),
        name: "The Admin",
        role: "admin"
      },
      %User{
        email: "charles@caffe.com",
        password: Password.hash("secret"),
        name: "Charles the Chef",
        role: "chef"
      },
      %User{
        email: "wolverine@caffe.com",
        password: Password.hash("secret"),
        name: "Wolverine the Waiter",
        role: "waitstaff"
      },
      %User{
        email: "cyclops@caffe.com",
        password: Password.hash("secret"),
        name: "Cyclops the Customer",
        role: "customer"
      }
    ])
  end

  defp create_menu do
    [sandwiches, sides, beverages] =
      upsert_all_by(:name, [
        %Menu.Category{name: "Sandwiches", position: 1},
        %Menu.Category{name: "Sides", position: 2},
        %Menu.Category{name: "Beverages", position: 3}
      ])

    upsert_all_by(:name, [
      %Menu.Item{name: "Reuben", price: 4.50, category: sandwiches},
      %Menu.Item{name: "Croque Monsieur", price: 6.25, category: sandwiches},
      %Menu.Item{name: "Muffuletta", price: 5.50, category: sandwiches},
      %Menu.Item{name: "Bánh mì", price: 7, category: sandwiches},
      %Menu.Item{name: "Vada Pav", price: 4.50, category: sandwiches},
      %Menu.Item{name: "Hamburger", price: 2, category: sandwiches},
      %Menu.Item{name: "French Fries", price: 2.50, category: sides},
      %Menu.Item{name: "Papadum", price: 1.25, category: sides},
      %Menu.Item{name: "Pasta Salad", price: 2.50, category: sides},
      %Menu.Item{name: "Thai Salad", price: 3.50, category: sides},
      %Menu.Item{name: "Water", price: 0, is_drink: true, category: beverages},
      %Menu.Item{name: "Beer", price: 1.5, is_drink: true, category: beverages},
      %Menu.Item{name: "Lemonade", price: 1.25, is_drink: true, category: beverages},
      %Menu.Item{name: "Masala Chai", price: 1.5, is_drink: true, category: beverages},
      %Menu.Item{name: "Milkshake", price: 3, is_drink: true, category: beverages}
    ])
  end

  defp upsert_by(record, conflict_target) do
    Repo.insert!(record,
      on_conflict: :replace_all_except_primary_key,
      conflict_target: conflict_target
    )
  end

  defp upsert_all_by(field, records) do
    Enum.map(records, &upsert_by(&1, field))
  end
end
