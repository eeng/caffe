defmodule Caffe.Router do
  use Commanded.Commands.Router

  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Aggregates.Order

  middleware Caffe.Middleware.Logger
  middleware Caffe.Middleware.Validator

  dispatch(
    [
      Commands.PlaceOrder,
      Commands.BeginFoodPreparation,
      Commands.MarkFoodPrepared,
      Commands.MarkItemsServed,
      Commands.PayOrder
    ],
    to: Order,
    identity: :order_id
  )
end
