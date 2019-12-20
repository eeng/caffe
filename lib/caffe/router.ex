defmodule Caffe.Router do
  use Commanded.Commands.Router
  use Caffe.Orders.Aliases
  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Aggregates.Order

  middleware Caffe.Middleware.Logger
  middleware Caffe.Middleware.Validator

  dispatch(
    [
      OpenTab,
      PlaceOrder,
      MarkItemsServed,
      BeginFoodPreparation,
      MarkFoodPrepared,
      CloseTab
    ],
    to: Tab,
    identity: :tab_id
  )

  dispatch(
    [
      Commands.PlaceOrder
    ],
    to: Order,
    identity: :order_id
  )
end
