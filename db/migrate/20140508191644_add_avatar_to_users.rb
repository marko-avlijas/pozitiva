class AddAvatarToUsers < ActiveRecord::Migration
  def change
    add_column :users, :avatar, :binary
    add_column :users, :avatar_mime_type, :string
  end
end
