defmodule CaffeWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  alias CaffeWeb.Resolvers
  alias CaffeWeb.Schema.Middleware

  object :user do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :role, non_null(:role)
    field :name, :string
  end

  enum :role do
    value :admin
    value :chef
    value :waitstaff
    value :customer
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  object :accounts_queries do
    field :users, list_of(:user) do
      middleware Middleware.Authorize, "admin"
      resolve &Resolvers.Accounts.list_users/3
    end
  end

  object :accounts_mutations do
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
      resolve &Resolvers.Accounts.login/3
    end
  end
end
