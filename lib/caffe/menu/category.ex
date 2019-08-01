defmodule Caffe.Menu.Category do
  use Ecto.Schema
  import Ecto.Changeset
  alias Caffe.Menu

  schema "categories" do
    field :name, :string
    field :position, :integer, default: 0
    has_many :items, Menu.Item
    timestamps()
  end

  def changeset(category, params) do
    category
    |> cast(params, [:name, :position])
    |> validate_required(:name)
    |> unique_constraint(:name)
  end
end
