defmodule Caffe.Accounts.UserTest do
  use ExUnit.Case, async: true

  import Caffe.Support.Validation
  alias Caffe.Accounts.User

  describe "validations" do
    test "role should be one of the predefined ones" do
      changeset = %User{} |> User.changeset(%{role: "other"})
      assert "is invalid" in errors_on(changeset).role
    end
  end
end
