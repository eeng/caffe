defmodule Caffe.Accounts.UseCases.CreateUser do
  use Caffe.Mediator.UseCase
  alias Caffe.Accounts.User

  defstruct [:user, :params]

  @impl true
  def authorize(%CreateUser{user: %{role: "admin"}}), do: true

  @impl true
  def execute(%CreateUser{params: params}) do
    %User{} |> User.changeset(params) |> Repo.insert()
  end
end
