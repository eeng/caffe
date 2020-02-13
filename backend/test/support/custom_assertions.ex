defmodule Caffe.Support.CustomAssertions do
  @doc """
  Asserts that both lists contain the same elements in the same order
  """
  defmacro assert_lists_equal(left, right, opts \\ []) do
    quote do
      opts = unquote(opts) |> Enum.into(%{})
      left = unquote(left) |> unify_for_comparison(opts)
      right = unquote(right) |> unify_for_comparison(opts)

      if left == right do
        true
      else
        raise ExUnit.AssertionError,
          message: "List element comparison failed",
          left: left,
          right: right,
          args: [unquote(left), unquote(right)]
      end
    end
  end

  @doc """
  Asserts that both lists contain the same elements in any order
  """
  defmacro assert_contain_exactly(left, right, opts \\ []) do
    quote do
      opts = Enum.into(unquote(opts), %{in_any_order: true})
      assert_lists_equal(unquote(left), unquote(right), opts)
    end
  end

  def unify_for_comparison(list, opts) do
    Enum.reduce(opts, list, fn
      {:by, by}, list -> list |> Enum.map(&Map.get(&1, by))
      {:in_any_order, true}, list -> list |> Enum.sort()
      {:in_any_order, false}, list -> list
    end)
  end

  @doc """
  Asserts that list contains all elements in sublist
  """
  defmacro assert_contain_all(sublist, list) do
    quote do
      sublist = unquote(sublist)
      list = unquote(list)

      if Enum.all?(sublist, &(&1 in list)) do
        true
      else
        raise ExUnit.AssertionError,
          message: "Not all elements were present on the list",
          left: sublist |> Enum.sort(),
          right: list |> Enum.sort(),
          args: [sublist, list]
      end
    end
  end
end
