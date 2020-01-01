defmodule CaffeWeb.Support.Authentication do
  @salt "NqzX9VNWK5A3tRJ7M5sN+5dz56R76sfVNFu58sUPI1OYrJ4w7w2NSMBBv+Y6OEFD"

  def sign(data) do
    Phoenix.Token.sign(CaffeWeb.Endpoint, @salt, data)
  end

  def verify(token) do
    Phoenix.Token.verify(CaffeWeb.Endpoint, @salt, token, max_age: 365 * 24 * 3600)
  end
end
