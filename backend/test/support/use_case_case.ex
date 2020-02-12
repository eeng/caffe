defmodule Caffe.UseCaseCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Caffe.DataCase
      alias Caffe.Mediator
      alias Caffe.Authorization.Authorizer
    end
  end
end
