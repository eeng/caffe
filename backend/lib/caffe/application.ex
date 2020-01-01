defmodule Caffe.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Caffe.Repo,
      CaffeWeb.Endpoint,
      Caffe.Ordering.Projections.Supervisor,
      {Absinthe.Subscription, [CaffeWeb.Endpoint]}
    ]

    opts = [strategy: :one_for_one, name: Caffe.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    CaffeWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
