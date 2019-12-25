defmodule CaffeWeb.Schema.OrderingTypes do
  use Absinthe.Schema.Notation
  alias CaffeWeb.Resolvers

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
      arg :items, non_null(list_of(:order_item_input))
      arg :notes, :string
      resolve &Resolvers.Ordering.place_order/3
    end

    field :cancel_order, :string do
      arg :order_id, :id
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
