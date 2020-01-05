defmodule CaffeWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation
  alias CaffeWeb.Resolvers
  alias CaffeWeb.Schema.Middleware

  object :user do
    field :id, :id
    field :email, non_null(:string)
    field :role, non_null(:role)
    field :name, :string

    field :permissions, list_of(:string) do
      resolve &Resolvers.Accounts.permissions/3
    end
  end

  enum :role do
    value :admin, as: "admin"
    value :chef, as: "chef"
    value :waitstaff, as: "waitstaff"
    value :cashier, as: "cashier"
    value :customer, as: "customer"
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  object :accounts_queries do
    field :me, :user do
      middleware Middleware.Authorize, :me
      resolve &Resolvers.Accounts.me/3
    end

    field :users, list_of(:user) do
      middleware Middleware.Authorize, :list_users
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
