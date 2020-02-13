defmodule Caffe.Accounts.UseCases.Authenticate do
  use Caffe.Mediator.UseCase
  alias Caffe.Accounts.{User, Password}

  defstruct [:email, :password]

  @impl true
  def execute(%Authenticate{email: email, password: password}) do
    user = Repo.get_by(User, email: email)

    with %{password: digest} <- user,
         true <- Password.valid?(password, digest) do
      {:ok, user}
    else
      _ -> {:error, :invalid_credentials}
    end
  end

  @impl true
  def authorize(%Authenticate{}), do: true
end
