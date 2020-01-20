defmodule Caffe.Factory do
  alias Caffe.{Repo, Menu, Ordering, Accounts}

  # Factories

  def build(:category) do
    %Menu.Category{name: "Sandwich #{sequence()}"}
  end

  def build(:menu_item) do
    %Menu.Item{
      name: "Menu #{sequence()}",
      price: Decimal.new(10),
      category: build(:category)
    }
  end

  def build(:food), do: build(:menu_item, is_drink: false)
  def build(:drink), do: build(:menu_item, is_drink: true)

  def build(:order) do
    %Ordering.Projections.Order{id: uuid()}
  end

  def build(:activity) do
    %Ordering.Projections.Activity{
      type: "OrderPlaced"
    }
  end

  def build(:user) do
    number = sequence()

    %Accounts.User{
      email: "user#{number}@acme.com",
      password: Accounts.Password.hash("secret"),
      role: "admin",
      name: "User #{number}"
    }
  end

  def build(:admin), do: build(:user, role: "admin")
  def build(:customer), do: build(:user, role: "customer")
  def build(:cashier), do: build(:user, role: "cashier")
  def build(:chef), do: build(:user, role: "chef")
  def build(:waitstaff), do: build(:user, role: "waitstaff")

  def build(:user, attributes) do
    build(:user) |> struct(attributes) |> Map.update!(:password, &Accounts.Password.hash/1)
  end

  def build(factory_name, attributes) when is_atom(factory_name) do
    factory_name |> build() |> struct(attributes)
  end

  def build(quantity, factory_name, attributes \\ []) when is_integer(quantity) do
    Enum.map(1..quantity, fn _ -> build(factory_name, attributes) end)
  end

  def insert!(quantity, factory_name, attributes) when is_integer(quantity) do
    Enum.map(1..quantity, fn _ -> insert!(factory_name, attributes) end)
  end

  def insert!(quantity, factory_name) when is_integer(quantity) do
    insert!(quantity, factory_name, %{})
  end

  def insert!(factory_name, attributes) when is_atom(factory_name) do
    factory_name |> build(attributes) |> Repo.insert!()
  end

  def insert!(factory_name) when is_atom(factory_name) do
    insert!(factory_name, %{})
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
