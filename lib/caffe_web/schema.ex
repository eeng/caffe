defmodule CaffeWeb.Schema do
  use Absinthe.Schema
  alias Caffe.Menu

  import_types CaffeWeb.Schema.MenuTypes

  query do
    import_fields :menu_queries
  end

  def context(ctx) do
    loader =
      Dataloader.new()
      |> Dataloader.add_source(Menu.Item, Menu.data())
      |> Dataloader.add_source(Menu.Category, Menu.data())

    Map.put(ctx, :loader, loader)
  end

  def plugins do
    [Absinthe.Middleware.Dataloader] ++ Absinthe.Plugin.defaults()
  end
end
