class AdditionsToUsersAndOffers < ActiveRecord::Migration
  def change
    add_column :users, :is_producer, :boolean, default: false
    add_column :users, :about_text, :text
    add_column :users, :about_url, :string
    add_column :users, :buyer_tag, :string
    # add_index  :users, :buyer_tag, :unique => true
    add_column :users, :requested_group_id, :integer
    
    add_column :users, :about_attach, :binary
    add_column :users, :about_attach_mime_type, :string
    add_column :users, :about_attach_file_size, :integer

    add_column :offers, :attach, :binary
    add_column :offers, :attach_mime_type, :string
    add_column :offers, :attach_file_size, :integer
  end
end
