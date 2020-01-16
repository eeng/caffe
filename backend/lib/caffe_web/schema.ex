defmodule CaffeWeb.Schema do
  use Absinthe.Schema
  alias Caffe.Menu
  alias CaffeWeb.Schema.Middleware

  import_types CaffeWeb.Schema.{AccountsTypes, MenuTypes, OrderingTypes}

  query do
    import_fields :accounts_queries
    import_fields :menu_queries
    import_fields :ordering_queries
  end

  mutation do
    import_fields :accounts_mutations
    import_fields :menu_mutations
    import_fields :ordering_mutations
  end

  subscription do
    import_fields :ordering_subscriptions
  end

  scalar :decimal do
    parse fn
      %{value: value}, _ when is_binary(value) -> Decimal.parse(value)
      _, _ -> :error
    end

    serialize &to_string/1
  end

  scalar :datetime do
    parse fn input ->
      case DateTime.from_iso8601(input.value) do
        {:ok, datetime, _} -> {:ok, datetime}
        _ -> :error
      end
    end

    serialize fn datetime ->
      DateTime.to_iso8601(datetime)
    end
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

  def middleware(middleware, field, object) do
    middleware
    |> apply(:errors, field, object)
  end

  defp apply(middleware, :errors, _field, %{identifier: :mutation}) do
    middleware ++ [Middleware.HandleErrors]
  end

  defp apply(middleware, _, _, _) do
    middleware
  end
end
