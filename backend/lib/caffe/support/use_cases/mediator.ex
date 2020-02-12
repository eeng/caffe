defmodule Caffe.Mediator do
  alias Caffe.Mediator.Middleware

  @middleware [Middleware.Logging, Middleware.Init, Middleware.Authorization]

  def dispatch(request) do
    handler = &request.__struct__.execute/1

    pipeline =
      @middleware
      |> Enum.reverse()
      |> Enum.reduce(handler, fn middleware, pipeline ->
        pipeline |> middleware.build()
      end)

    pipeline.(request)
  end
end
