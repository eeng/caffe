defmodule CaffeWeb.Schema.OrderingTypes do
  use Absinthe.Schema.Notation
  alias CaffeWeb.Resolvers
  alias CaffeWeb.Schema.Middleware

  object :order do
    field :id, :id
    field :customer, :user
    field :customer_id, :integer
    field :state, :string
    field :order_amount, :decimal
    field :items, list_of(:order_item)
    field :notes, :string
  end

  object :order_item do
    field :menu_item_id, :integer
    field :menu_item_name, :string
    field :quantity, :integer
    field :price, :decimal
  end

  input_object :order_item_input do
    field :menu_item_id, non_null(:integer)
    field :quantity, non_null(:integer)
  end

  object :ordering_mutations do
    field :place_order, :order do
      arg :items, non_null(list_of(non_null(:order_item_input)))
      arg :notes, :string
      middleware Middleware.Authorize, :place_order
      resolve &Resolvers.Ordering.place_order/3
    end

    field :mark_items_served, :string do
      arg :order_id, non_null(:id)
      arg :item_ids, non_null(list_of(non_null(:id)))
      middleware Middleware.Authorize, :mark_items_served
      resolve &Resolvers.Ordering.mark_items_served/3
    end

    field :begin_food_preparation, :string do
      arg :order_id, non_null(:id)
      arg :item_ids, non_null(list_of(non_null(:id)))
      middleware Middleware.Authorize, :begin_food_preparation
      resolve &Resolvers.Ordering.begin_food_preparation/3
    end

    field :mark_food_prepared, :string do
      arg :order_id, non_null(:id)
      arg :item_ids, non_null(list_of(non_null(:id)))
      middleware Middleware.Authorize, :mark_food_prepared
      resolve &Resolvers.Ordering.mark_food_prepared/3
    end

    field :pay_order, :string do
      arg :order_id, non_null(:id)
      arg :amount_paid, non_null(:decimal)
      middleware Middleware.Authorize, :pay_order
      resolve &Resolvers.Ordering.pay_order/3
    end

    field :cancel_order, :string do
      arg :order_id, non_null(:id)
      middleware Middleware.Authorize, :cancel_order
      resolve &Resolvers.Ordering.cancel_order/3
    end
  end

  object :ordering_subscriptions do
    field :new_order, :order do
      config fn _args, %{context: context} ->
        case context[:current_user] do
          %{role: "customer", id: id} -> {:ok, topic: id}
          %{role: _} -> {:ok, topic: "*"}
          _ -> {:error, :unauthorized}
        end
      end

      trigger :place_order, topic: fn order -> [order.customer_id, "*"] end
    end
  end
end
