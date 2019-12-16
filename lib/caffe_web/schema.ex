defmodule CaffeWeb.Schema do
  use Absinthe.Schema

  import_types CaffeWeb.Schema.MenuTypes

  query do
    import_fields :menu_queries
  end
end
