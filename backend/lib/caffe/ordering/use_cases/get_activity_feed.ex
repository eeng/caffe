defmodule Caffe.Ordering.UseCases.GetActivityFeed do
  use Caffe.Mediator.UseCase

  alias Caffe.Accounts.User
  alias Caffe.Ordering.Projections.Activity

  defstruct [:user]

  @impl true
  def authorize(%GetActivityFeed{user: %User{role: role}}), do: role != "customer"

  @impl true
  def execute(%GetActivityFeed{}) do
    {:ok, query() |> Repo.all()}
  end

  def query do
    from o in Activity, order_by: [desc: o.published], preload: [:actor], limit: 100
  end
end
