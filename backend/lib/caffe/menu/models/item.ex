defmodule Caffe.Menu.Item do
  use Ecto.Schema
  use Arc.Ecto.Schema
  import Ecto.Changeset

  schema "menu_items" do
    field :name, :string
    field :description, :string
    belongs_to :category, Caffe.Menu.Category
    field :price, :decimal
    field :is_drink, :boolean, default: false
    field :image, Caffe.Menu.Image.Type
    timestamps()
  end

  def changeset(menu_item, attrs) do
    menu_item
    |> cast(attrs, [:name, :description, :price, :is_drink, :category_id])
    |> cast_attachments(attrs, [:image], allow_paths: true)
    |> validate_required([:name, :price])
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> unique_constraint(:name)
    |> foreign_key_constraint(:category_id)
  end
end
