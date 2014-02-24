class ChangeIsPackageInOfferItems < ActiveRecord::Migration
  def change
    remove_column :offer_items, :is_package
    add_column :offer_items, :packaging, :string
    add_column :offer_items, :packaging_description, :string
    
    remove_column :order_items, :solidary_qty
    remove_column :order_items, :solidary_qty_changed_at
    
    add_column :order_items, :corrected_qty, :decimal, precision: 7, scale: 1
    add_column :order_items, :qty_corrected_at, :datetime
  end
end
