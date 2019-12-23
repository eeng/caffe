defmodule CaffeWeb.SubscriptionCase do
  @moduledoc """
  This module defines the test case to be used by subscription tests
  """
  use ExUnit.CaseTemplate

  using do
    quote do
      use CaffeWeb.ChannelCase
      use Absinthe.Phoenix.SubscriptionTest, schema: CaffeWeb.Schema
      import Caffe.Factory

      defp connect(:guest) do
        connect(%{})
      end

      defp connect(%Caffe.Accounts.User{id: user_id}) do
        token = CaffeWeb.Support.Authentication.sign(%{user_id: user_id})
        connect(%{token: token})
      end

      defp connect(params) do
        {:ok, socket} = Phoenix.ChannelTest.connect(CaffeWeb.UserSocket, params)
        {:ok, socket} = Absinthe.Phoenix.SubscriptionTest.join_absinthe(socket)
        socket
      end

      defp subscribe_as(user, subscription) do
        socket = connect(user)
        ref = push_doc(socket, subscription)
        assert_reply ref, status, reply
        {status, reply}
      end
    end
  end
end
