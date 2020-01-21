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
        name: "Charles (Chef)",
        role: "chef"
      },
      %User{
        email: "wendy@caffe.com",
        password: Password.hash("secret"),
        name: "Wendy (Waiter)",
        role: "waitstaff"
      },
      %User{
        email: "alice@caffe.com",
        password: Password.hash("secret"),
        name: "Alice (Customer)",
        role: "customer"
      },
      %User{
        email: "bob@caffe.com",
        password: Password.hash("secret"),
        name: "Bob (Customer)",
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
      %Menu.Item{
        name: "Reuben",
        price: 4.50,
        category: sandwiches,
        image: fixture("Reuben.jpg"),
        description: """
        The Reuben sandwich is an American grilled sandwich composed of corned beef,
        Swiss cheese, sauerkraut, and Russian dressing, grilled between slices of rye bread.
        """
      },
      %Menu.Item{
        name: "Croque Monsieur",
        price: 6.25,
        category: sandwiches,
        image: fixture("Croque_Monsieur.jpg"),
        description: "A croque monsieur is a baked or fried boiled ham and cheese sandwich."
      },
      %Menu.Item{
        name: "Muffuletta",
        price: 5.50,
        category: sandwiches,
        image: fixture("Muffuletta.jpg"),
        description: """
        Consists of a muffuletta loaf split horizontally and covered with layers of marinated
        muffuletta-style olive salad, salami, ham, Swiss cheese, provolone, and mortadella.
        """
      },
      %Menu.Item{
        name: "Bánh mì",
        price: 7,
        category: sandwiches,
        image: fixture("Banh_Mi.jpg"),
        description: """
        Is a fusion of meats and vegetables from native Vietnamese cuisine such as chả lụa (pork sausage),
        coriander leaf (cilantro), cucumber, pickled carrots, and pickled daikon.
        """
      },
      %Menu.Item{
        name: "Vada Pav",
        price: 4.50,
        category: sandwiches,
        image: fixture("Vada_Pav.jpg"),
        description: """
        It's a vegetarian fast food dish native to the state of Maharashtra. The dish consists of a
        deep fried potato dumpling placed inside a bread bun sliced almost in half through the middle.
        """
      },
      %Menu.Item{
        name: "Hamburger",
        price: 2,
        category: sandwiches,
        image: fixture("Hamburger.jpg"),
        description: """
        A hamburger is a sandwich consisting of one or more cooked patties of ground meat, usually beef,
        placed inside a sliced bread roll or bun. The patty may be pan fried, grilled, smoked or flame broiled.
        """
      },
      %Menu.Item{
        name: "Kalamarakia Tiganita",
        price: 2.50,
        category: sides,
        image: fixture("Kalamarakia_Tiganita.jpg"),
        description: """
        Crispy and perfectly seasoned fried calamari (kalamarakia tiganita) recipe!
        """
      },
      %Menu.Item{
        name: "Papadum",
        price: 1.25,
        category: sides,
        image: fixture("Papadum.jpg"),
        description: """
        A papadum is a thin, crisp, round flatbread from the Indian subcontinent.
        It is typically based on a seasoned dough usually made from peeled black gram flour,
        either fried or cooked with dry heat.
        """
      },
      %Menu.Item{
        name: "Pasta Salad",
        price: 2.50,
        category: sides,
        image: fixture("Pasta_Salad.jpg"),
        description: """
        An Italian pasta salad with rotini, juicy tomatoes, fresh mozzarella, red onion,
        salami, olives, herbs, and a drench of quick homemade Italian dressing.
        """
      },
      %Menu.Item{
        name: "Thai Salad",
        price: 3.50,
        category: sides,
        image: fixture("Thai_Salad.jpg")
      },
      %Menu.Item{name: "Water", price: 0, is_drink: true, category: beverages},
      %Menu.Item{name: "Beer", price: 1.5, is_drink: true, category: beverages},
      %Menu.Item{name: "Lemonade", price: 1.25, is_drink: true, category: beverages},
      %Menu.Item{
        name: "Masala Chai",
        price: 1.5,
        is_drink: true,
        category: beverages,
        image: fixture("Masala_Chai.jpg"),
        description: """
        Masala chai is a flavoured tea beverage made by brewing black tea with a mixture
        of aromatic Indian spices and herbs.
        """
      },
      %Menu.Item{name: "Milkshake", price: 3, is_drink: true, category: beverages}
    ])
  end

  # We need to pass through the changeset for the image to be assigned (by the cast_attachments).
  # Also, because we are using the id for the storage_dir, we must insert the record before setting the attachment.
  defp upsert_by(%Menu.Item{image: image} = record, conflict_target) do
    {:ok, record} =
      Map.delete(record, :image)
      |> upsert_by(conflict_target)
      |> Menu.Item.changeset(%{image: image})
      |> Repo.update()

    record
  end

  defp upsert_by(record, conflict_target) do
    Repo.insert!(record,
      on_conflict: {:replace_all_except, [:id]},
      conflict_target: conflict_target
    )
  end

  defp upsert_all_by(field, records) do
    Enum.map(records, &upsert_by(&1, field))
  end

  def fixture(filename) do
    "priv/repo/fixtures/#{filename}"
  end
end
