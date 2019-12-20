defmodule CaffeWeb.Router do
  use CaffeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
    plug CaffeWeb.Schema.Context
  end

  scope "/api" do
    pipe_through :api

    forward "/graphiql", Absinthe.Plug.GraphiQL, schema: CaffeWeb.Schema

    forward "/", Absinthe.Plug, schema: CaffeWeb.Schema
  end
end
