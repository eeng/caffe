defmodule CaffeWeb.Schema.AccountsTypes do
  use Absinthe.Schema.Notation

  object :user do
    field :email, non_null(:string)
    field :password, non_null(:string)
    field :role, non_null(:role)
  end

  object :session do
    field :token, :string
    field :user, :user
  end

  enum :role do
    value :admin
    value :chef
    value :waitstaff
    value :customer
  end

  object :accounts_mutations do
    field :login, :session do
      arg :email, non_null(:string)
      arg :password, non_null(:string)
    end
  end
end
