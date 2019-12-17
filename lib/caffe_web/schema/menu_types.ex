defmodule CaffeWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]

  alias CaffeWeb.Resolvers
  alias Caffe.Menu

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :is_drink, :boolean
    field :category, :category, resolve: dataloader(Menu.Category)
  end

  object :category do
    field :id, :id
    field :name, :string
    field :position, :integer
    field :items, list_of(:menu_item), resolve: dataloader(Menu.Item)
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

  input_object :menu_item_input do
    field :id, :id
    field :name, non_null(:string)
    field :description, :string
    field :price, non_null(:decimal)
    field :is_drink, :boolean
    field :category_id, non_null(:integer)
  end

  object :menu_mutations do
    field :save_menu_item, :menu_item do
      arg :input, non_null(:menu_item_input)
      resolve &Resolvers.Menu.save_item/3
    end

    field :delete_menu_item, :boolean do
      arg :id, non_null(:id)
      resolve &Resolvers.Menu.delete_item/3
    end
  end
end
