defmodule CaffeWeb.Schema.MenuTypes do
  use Absinthe.Schema.Notation
  import Absinthe.Resolution.Helpers, only: [dataloader: 1]
  alias Caffe.Menu
  alias CaffeWeb.Resolvers

  object :menu_item do
    field :id, :id
    field :name, :string
    field :description, :string
    field :price, :decimal
    field :is_drink, :boolean
    field :category_id, :id
    field :category, :category, resolve: dataloader(Menu.Category)

    field :image_url, :string do
      resolve &Resolvers.Menu.image_url/3
    end
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

    @desc "Get a single item by id"
    field :menu_item, :menu_item do
      arg :id, :id
      resolve &Resolvers.Menu.find_item/3
    end

    @desc "Get all menu categories"
    field :categories, list_of(:category) do
      resolve &Resolvers.Menu.list_categories/3
    end
  end

  object :menu_mutations do
    field :create_menu_item, :menu_item do
      arg :name, non_null(:string)
      arg :description, :string
      arg :price, non_null(:decimal)
      arg :is_drink, :boolean
      arg :category_id, non_null(:id)
      resolve &Resolvers.Menu.create_item/3
    end

    field :update_menu_item, :menu_item do
      arg :id, non_null(:id)
      arg :name, :string
      arg :description, :string
      arg :price, :decimal
      arg :is_drink, :boolean
      arg :category_id, :id
      resolve &Resolvers.Menu.update_item/3
    end

    field :delete_menu_item, :menu_item do
      arg :id, non_null(:id)
      resolve &Resolvers.Menu.delete_item/3
    end
  end
end
