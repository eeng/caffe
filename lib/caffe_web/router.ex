defmodule CaffeWeb.Router do
  use CaffeWeb, :router

  pipeline :api do
    plug :accepts, ["json"]
  end

  scope "/api", CaffeWeb do
    pipe_through :api
  end
end
