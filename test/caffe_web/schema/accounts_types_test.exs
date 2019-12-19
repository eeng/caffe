defmodule CaffeWeb.Schema.AccountsTypesTest do
  use CaffeWeb.ConnCase, async: true
  alias CaffeWeb.Support.Authentication

  @query """
  mutation ($email: String, $password: String) {
    login(email: $email, password: $password) {
      token
      user { name }
    }
  }
  """
  describe "login mutation" do
    test "valid credentials should return a token" do
      credentials = %{email: "john@doe.com", password: "I dont know"}
      %{id: user_id} = insert!(:user, Map.put(credentials, :name, "John Doe"))

      conn = build_conn() |> post("/api", query: @query, variables: credentials)

      assert %{
               "data" => %{
                 "login" => %{
                   "token" => token,
                   "user" => %{"name" => "John Doe"}
                 }
               }
             } = json_response(conn, 200)

      assert {:ok, %{user_id: ^user_id}} = Authentication.verify(token)
    end

    test "invalid credentials" do
      credentials = %{email: "max@payne.com", password: "secret"}
      conn = build_conn() |> post("/api", query: @query, variables: credentials)

      assert %{
               "data" => %{"login" => nil},
               "errors" => [%{"message" => "invalid_credentials"}]
             } = json_response(conn, 200)
    end
  end
end
