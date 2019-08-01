defmodule Caffe.Menu.Item do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caffe.Menu.Category

  schema "menu_items" do
    field :name, :string
    field :description, :string
    belongs_to :category, Category
    field :price, :decimal
    field :is_drink, :boolean, default: false
    timestamps()
  end

  def changeset(menu_item, attrs) do
    menu_item
    |> cast(attrs, [:name, :description, :price, :is_drink])
    |> validate_required([:name, :price])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
    |> foreign_key_constraint(:category)
  end
end
