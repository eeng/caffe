defmodule Caffe.Sigils do
  defmacro sigil_d(value_ast, _) do
    {_, _, [value]} = value_ast
    Macro.escape(Decimal.new(value))
  end
end
