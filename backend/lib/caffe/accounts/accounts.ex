defmodule Caffe.Accounts do
  alias Caffe.Repo
  alias Caffe.Mediator
  alias Caffe.Accounts.UseCases.{Authenticate, CreateUser, ListUsers, Me}
  alias Caffe.Accounts.User

  def authenticate(email, password) do
    %Authenticate{email: email, password: password} |> Mediator.dispatch()
  end

  def create_user(params, user) do
    %CreateUser{user: user, params: params} |> Mediator.dispatch()
  end

  def list_users(user) do
    %ListUsers{user: user} |> Mediator.dispatch()
  end

  def me(user) do
    %Me{user: user} |> Mediator.dispatch()
  end

  def get_user(id) do
    Repo.fetch(User, id)
  end
end
