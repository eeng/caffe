defmodule Caffe.Menus.Menu do
  @moduledoc """
  Just a wrapper around the menu items for now.
  In a real-world scenario we could have different menus for different days for example.
  """

  @derive Jason.Encoder
  defstruct items: []
end
