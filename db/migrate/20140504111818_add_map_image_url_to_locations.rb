class AddMapImageUrlToLocations < ActiveRecord::Migration
  def change
    add_column :locations, :map_image_url, :string
  end
end
