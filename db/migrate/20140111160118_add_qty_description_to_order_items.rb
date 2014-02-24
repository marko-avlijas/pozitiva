class AddQtyDescriptionToOrderItems < ActiveRecord::Migration
  def change
    add_column :order_items, :qty_description, :string
  end
end
