class AddCompanyToUsers < ActiveRecord::Migration
  def change
    add_column :users, :company_name, :string
    add_column :users, :company_address, :string
    add_column :users, :company_oib, :string
    
    add_column :offers, :company_name, :string
    add_column :offers, :company_address, :string
    add_column :offers, :company_oib, :string
    add_column :offers, :dispatch_place, :string
    add_column :offers, :dispatch_date, :datetime
  end
end
