defmodule Caffe.Router do
  use Commanded.Commands.Router
  use Caffe.Orders.Aliases

  middleware Caffe.Middleware.Logger
  middleware Caffe.Middleware.Validator

  dispatch [OpenTab],
    to: Tab,
    identity: :tab_id
end
