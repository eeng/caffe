defmodule CaffeWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation
  alias CaffeWeb.Resolvers

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :price, :float
    field :category, :category
  end

  object :category do
    field :id, :id
    field :name, :string
    field :position, :integer
  end

  object :menu_queries do
    @desc "Get all menu items"
    field :menu_items, list_of(:menu_item) do
      resolve &Resolvers.Menu.list_items/3
    end

    @desc "Get all menu categories"
    field :categories, list_of(:category) do
      resolve &Resolvers.Menu.list_categories/3
    end
  end
end
