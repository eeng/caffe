defmodule Caffe.Menus.MenuItem do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  schema "menu_items" do
    field :name, :string
    field :description, :string
    field :category, :string
    field :price, :integer

    timestamps()
  end

  def changeset(menu_item, attrs) do
    menu_item
    |> cast(attrs, [:name, :description, :category, :price])
    |> validate_required([:name, :category, :price])
    |> validate_number(:price, greater_than: 0)
    |> unique_constraint(:name)
  end
end
