defmodule Caffe.Router do
  use Commanded.Commands.Router, application: Caffe.Commanded.Application

  alias Caffe.Ordering.Commands
  alias Caffe.Ordering.Aggregates.Order

  middleware Caffe.Middleware.Validator

  dispatch(
    [
      Commands.PlaceOrder,
      Commands.BeginFoodPreparation,
      Commands.MarkFoodPrepared,
      Commands.MarkItemsServed,
      Commands.PayOrder,
      Commands.CancelOrder
    ],
    to: Order,
    identity: :order_id
  )
end
