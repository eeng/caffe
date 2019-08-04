defmodule Caffe.Orders.Commands.BeginFoodPreparation do
  defstruct [:tab_id, :item_ids]

  use Caffe.Command

  validates :tab_id, uuid: true
  validates :item_ids, by: &is_list/1, length: [min: 1]
end
