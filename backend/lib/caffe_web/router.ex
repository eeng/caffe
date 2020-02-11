defmodule CaffeWeb.Router do
  use CaffeWeb, :router
  @dialyzer :no_return

  pipeline :api do
    plug :accepts, ["json"]
    plug CaffeWeb.Schema.Context
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL,
      schema: CaffeWeb.Schema,
      socket: CaffeWeb.UserSocket,
      interface: :playground

    forward "/", Absinthe.Plug, schema: CaffeWeb.Schema, log_level: :info
  end
end
