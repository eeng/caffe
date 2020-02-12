defmodule Caffe.Accounts.UseCases.Me do
  use Caffe.Mediator.UseCase
  alias Caffe.Accounts.User

  defstruct [:user]

  @impl true
  def authorize(%Me{user: %User{}}), do: true

  @impl true
  def execute(%Me{user: %User{id: id}}) do
    Repo.fetch(User, id)
  end
end
