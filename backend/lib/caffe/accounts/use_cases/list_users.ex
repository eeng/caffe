defmodule Caffe.Accounts.UseCases.ListUsers do
  use Caffe.Mediator.UseCase
  alias Caffe.Accounts.User

  defstruct [:user]

  @impl true
  def execute(_) do
    {:ok, Repo.all(User)}
  end

  @impl true
  def authorize(%ListUsers{user: %{role: "admin"}}), do: true
end
