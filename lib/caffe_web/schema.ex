defmodule CaffeWeb.Schema do
  use Absinthe.Schema
  alias Caffe.Menu
  alias CaffeWeb.Schema.Middleware

  import_types CaffeWeb.Schema.MenuTypes
  import_types CaffeWeb.Schema.AccountsTypes

  query do
    import_fields :menu_queries
  end

  mutation do
    import_fields :menu_mutations
    import_fields :accounts_mutations
  end

  scalar :decimal do
    parse fn
      %{value: value}, _ when is_binary(value) -> Decimal.parse(value)
      _, _ -> :error
    end

    serialize &to_string/1
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

  def middleware(middleware, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.ChangesetErrors]
  end

  def middleware(middleware, _field, _object) do
    middleware
  end
end
