class AddIsPremiumToUsers < ActiveRecord::Migration
  def change
    add_column :users, :is_premium, :boolean, null: false, default: false
  end
end
