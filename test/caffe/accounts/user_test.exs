defmodule Caffe.Accounts.UserTest do
  use ExUnit.Case, async: true

  import Caffe.Support.Validation
  alias Caffe.Accounts.User

  describe "validations" do
    test "email should be present and have the correct format" do
      assert {:email, "can't be blank"} in errors_on(User, %{email: ""})
      assert {:email, "has invalid format"} in errors_on(User, %{email: "nop"})
      refute {:email, "has invalid format"} in errors_on(User, %{email: "yes@a.com"})
    end

    test "role should be one of the predefined ones" do
      assert {:role, "is invalid"} in errors_on(User, %{role: "other"})
    end
  end
end
