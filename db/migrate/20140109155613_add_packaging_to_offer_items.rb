class AddPackagingToOfferItems < ActiveRecord::Migration
  def change
    remove_column :offer_items, :unit
    remove_column :offer_items, :price
    
    add_column :offer_items, :unit_bulk, :string
    add_column :offer_items, :price_bulk, :integer

    add_column :offer_items, :unit_package, :string
    add_column :offer_items, :price_package, :integer

    add_column :offer_items, :unit_vario, :string
    add_column :offer_items, :price_vario, :integer
  end
end
