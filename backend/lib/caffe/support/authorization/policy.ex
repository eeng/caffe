defmodule Caffe.Authorization.Policy do
  @callback actions() :: [atom]
  @callback authorize(action :: atom, user :: any, params :: any) :: boolean
end
