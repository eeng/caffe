defmodule Caffe.Support.CustomAssertionsTest do
  use ExUnit.Case, async: true
  import Caffe.Support.CustomAssertions

  describe "assert_contain_exactly" do
    test "should assert that the lists contain the same elements in any order" do
      assert_contain_exactly([1, 2, 3], [2, 3, 1])

      assert_raise ExUnit.AssertionError, fn ->
        assert_contain_exactly([1, 2, 3], [2, 3, 11])
      end
    end

    test "should allow to indicate a field to compare when the elements are structs" do
      assert_contain_exactly([%{id: 1}, %{id: 2}], [%{id: 2}, %{id: 1, dont_care: true}], by: :id)
      assert_contain_exactly([%{id: 1}, %{id: 2, dont_care: true}], [%{id: 2}, %{id: 1}], by: :id)

      assert_raise ExUnit.AssertionError, fn ->
        assert_contain_exactly([%{id: 1}, %{id: 2}], [%{id: 2}, %{id: 1, do_care: true}])
        assert_contain_exactly([%{id: 1}, %{id: 2}], [%{id: 2}, %{id: 11}], by: :id)
      end
    end
  end

  describe "assert_lists_equal" do
    test "should assert that the lists contain the same elements in the same order" do
      assert_lists_equal([1, 2, 3], [1, 2, 3])

      assert_raise ExUnit.AssertionError, fn ->
        assert_lists_equal([1, 2, 3], [2, 3, 1])
      end
    end

    test "should allow to indicate a field to compare when the elements are structs" do
      assert_lists_equal([%{id: 1}, %{id: 2}], [%{id: 1}, %{id: 2, dont_care: true}], by: :id)

      assert_raise ExUnit.AssertionError, fn ->
        assert_lists_equal([%{id: 1}, %{id: 2}], [%{id: 2}, %{id: 1}], by: :id)
      end
    end
  end
end
